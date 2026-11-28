extends CharacterBody3D
const AvatarVisual=preload("res://avatar_visual.gd")
var visual:Node3D
var geo:Dictionary
var token:String
var character:Dictionary
var world:Node3D
var http:HTTPRequest
var busy:=false
var clock:=0.0
var target:Variant=null
var desired:=Vector2.ZERO
var test_direction:=Vector2.ZERO
var interaction_locked:=false
var running:=false
var authority:=Vector2.ZERO
var zone:="safe"
var online:=true
var walk_clip:="Idle"
var sent:=0
var received:=0
signal state_changed
signal session_lost

func setup(w:Node3D,c:Dictionary,state:Dictionary,session:String)->void:
	world=w
	character=c
	token=session
	geo=JSON.parse_string(FileAccess.get_file_as_string("res://world/forest_collision.json" if state.get("map")=="bosque" else "res://world/collision.json"))
	collision_layer=2
	collision_mask=1
	motion_mode=CharacterBody3D.MOTION_MODE_FLOATING
	var shape:=CollisionShape3D.new()
	var cap:=CapsuleShape3D.new()
	cap.radius=.32
	cap.height=1.7
	shape.shape=cap
	shape.position.y=.85
	add_child(shape)
	visual=AvatarVisual.create(c.get("appearance",{}))
	add_child(visual)
	AvatarVisual.play(visual,"Idle",0)
	position=Vector3(state["x"],0,state["z"])
	authority=Vector2(position.x,position.z)
	zone=state.get("zone","safe")
	http=HTTPRequest.new()
	http.timeout=2
	add_child(http)
	http.request_completed.connect(on_response)

func walkable(p:Vector2)->bool:
	var r:=float(geo["radius"])
	var b:Array=geo["bounds"]
	if p.x<float(b[0]) or p.x>float(b[1]) or p.y<float(b[2]):return false
	var shore:=26.5+1.8*sin(p.x*.12)+.9*sin(p.x*.26+1.2)
	if geo.has("max_z") and p.y>float(geo["max_z"]):return false
	if not geo.has("max_z") and p.y>shore-r:
		var on_pier:=false
		for pier in geo["piers"]:
			if absf(p.x-float(pier["x"]))<=float(pier["hx"])-r and absf(p.y-float(pier["z"]))<=float(pier["hz"])-r:on_pier=true
		if not on_pier:return false
	for box in geo["boxes"]:
		var a:=deg_to_rad(float(box["rot"]))
		var dx:=p.x-float(box["x"])
		var dz:=p.y-float(box["z"])
		var lx:=dx*cos(a)-dz*sin(a)
		var lz:=dx*sin(a)+dz*cos(a)
		var ox:=maxf(0,absf(lx)-float(box["hx"]))
		var oz:=maxf(0,absf(lz)-float(box["hz"]))
		if ox*ox+oz*oz<r*r:return false
	return true
func _physics_process(delta:float)->void:
	if not is_instance_valid(visual) or not online:return
	var d:=Vector2.ZERO
	if Input.is_physical_key_pressed(KEY_W):d.y-=1
	if Input.is_physical_key_pressed(KEY_S):d.y+=1
	if Input.is_physical_key_pressed(KEY_A):d.x-=1
	if Input.is_physical_key_pressed(KEY_D):d.x+=1
	if interaction_locked:
		desired=Vector2.ZERO
		target=null
	elif test_direction!=Vector2.ZERO:
		desired=test_direction.normalized()
	elif d!=Vector2.ZERO:
		target=null
		var r:=deg_to_rad(world.azimuth)
		var v:=Vector3(d.x,0,d.y).rotated(Vector3.UP,r)
		desired=Vector2(v.x,v.z).normalized()
	elif target is Vector2:
		var gap:Vector2=target-Vector2(position.x,position.z)
		desired=gap.normalized() if gap.length()>.35 else Vector2.ZERO
		if desired==Vector2.ZERO:target=null
	else:desired=Vector2.ZERO
	running=Input.is_physical_key_pressed(KEY_SHIFT)
	var speed:=6.0 if running else 4.5
	var prev:=position
	var step:=desired*speed*delta
	var p:=Vector2(position.x,position.z)
	var next:=p+step
	if not walkable(next):
		if walkable(Vector2(next.x,p.y)):next.y=p.y
		elif walkable(Vector2(p.x,next.y)):next.x=p.x
		else:next=p
	var valid_step:=next-p
	velocity=Vector3(valid_step.x,0,valid_step.y)/maxf(delta,.001)
	move_and_slide()
	position.y=0
	var actual:=Vector2(position.x-prev.x,position.z-prev.z)
	if target is Vector2 and actual.length()<.0001:target=null
	if actual.length()>.0002:
		visual.rotation.y=lerp_angle(visual.rotation.y,atan2(actual.x,actual.y),minf(delta*15,1))
		walk_clip="Run" if running else "Walk"
	else:walk_clip="Idle"
	AvatarVisual.play(visual,walk_clip)
	clock+=delta
	if clock>=.1 and not busy:
		clock=0
		send()
func send()->void:
	var headers:=PackedStringArray(["Content-Type: application/json","Authorization: Bearer "+token])
	var body:=JSON.stringify({"dx":desired.x,"dz":desired.y,"run":running})
	busy=true
	var err:=http.request("http://127.0.0.1:3000/v1/world/move",headers,HTTPClient.METHOD_POST,body)
	if err!=OK:busy=false;online=false;state_changed.emit()
	else:sent+=1
func on_response(result:int,code:int,_headers:PackedStringArray,body:PackedByteArray)->void:
	busy=false
	if result!=HTTPRequest.RESULT_SUCCESS or code!=200:
		online=false
		state_changed.emit()
		if code==401 or code==404:session_lost.emit()
		return
	var data:Variant=JSON.parse_string(body.get_string_from_utf8())
	if not data is Dictionary or data.get("character_id")!=character.get("id"):
		online=false;state_changed.emit();return
	received+=1
	authority=Vector2(data["x"],data["z"])
	zone=data.get("zone","safe")
	var local:=Vector2(position.x,position.z)
	var error:=authority-local
	# Prediction is visual only; correct from authoritative response, including blocked motion.
	if error.length()>.6 or desired==Vector2.ZERO:
		position.x=authority.x
		position.z=authority.y
	elif error.length()>.12:
		var correction:=local.lerp(authority,.28)
		if walkable(correction):
			position.x=correction.x
			position.z=correction.y
	state_changed.emit()
