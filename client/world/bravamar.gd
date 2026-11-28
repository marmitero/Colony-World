extends Node3D
## P0.5 Bravamar, movement and collision; combat and NPC interaction pending.
const Player=preload("res://world/player.gd")
var player:CharacterBody3D
var state:Dictionary={}
var session_token:String=""
var collision_count:=0
var layout:Dictionary
var camera:Camera3D
var focus:=Vector3(0,0,0)
var azimuth:=25.0
var zoom:=20.0
# 0: superior, 1: terceira pessoa, 2: primeira pessoa.
var camera_mode:=0
var pitch:=15.0
var third_distance:=5.5
var look_drag:=false
var player_marker:Label3D
signal camera_mode_changed(mode:int)
var boats:Array[Node3D]=[]
var markers:Array[Label3D]=[]
var anchors:Dictionary={}
var npc_catalog:Dictionary={}
var npc_markers:Dictionary={}
var dialog_open:=false
signal npc_requested(id:String)
var instances:=0
var elapsed:=0.0
var animate:=true
var selected:Dictionary={}
var enabled:=true

func _ready()->void:
	layout=JSON.parse_string(FileAccess.get_file_as_string("res://world/bravamar.json"))
	for npc in JSON.parse_string(FileAccess.get_file_as_string("res://world/npcs.json")):
		npc_catalog[npc["id"]]=npc
	var env:=Environment.new()
	env.background_mode=Environment.BG_COLOR
	env.background_color=Color("#b8cbd1")
	env.ambient_light_source=Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color=Color("#e0e6df")
	env.ambient_light_energy=.8
	var world:=WorldEnvironment.new()
	world.environment=env
	add_child(world)
	var sun:=DirectionalLight3D.new()
	sun.rotation_degrees=Vector3(-52,-38,0)
	sun.light_color=Color("#ffe0b8")
	sun.light_energy=1.15
	sun.shadow_enabled=true
	add_child(sun)
	for m in layout["meshes"]:
		make_surface(m)
	var water:=MeshInstance3D.new()
	var plane:=PlaneMesh.new()
	plane.size=Vector2(140,60)
	plane.subdivide_width=60
	plane.subdivide_depth=30
	water.mesh=plane
	var wm:=ShaderMaterial.new()
	wm.shader=preload("res://water.gdshader")
	wm.set_shader_parameter("deep_color",Color("#477a8b"))
	wm.set_shader_parameter("glow_color",Color("#8eb2ac"))
	water.material_override=wm
	water.position=Vector3(0,-.24,52)
	add_child(water)
	for p in layout["placements"]:
		var model:=place(p)
		if p["kind"]=="boat":boats.append(model)
		if p["kind"]=="npc":
			anchors[p["id"]]=model
			var npc:Dictionary=npc_catalog[p["id"]]
			add_marker(npc["name"]+" · "+npc["role"],model.position+Vector3(0,2.15,0),Color(npc["color"]),22)
			npc_markers[p["id"]]=markers[-1]
		elif p["kind"]=="building" and p.has("service") and not String(p["service"]).begins_with("home"):
			add_marker(p["label"],model.position+Vector3(0,6.5,0),Color("#e0e5c8"),22)
	for e in layout["exits"]:
		add_marker("↗ "+e["label"]+" · "+e["level"],Vector3(e["x"],2.6,e["z"]),Color("#d4e8b4"),32)
	add_marker("ARENA  ·  PvP futuro",Vector3(0,2.8,-1),Color("#ffd0a1"),34)
	add_marker("Porto de Bravamar",Vector3(7,2.2,25),Color("#e1d7bd"),30)
	var geo:Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://world/collision.json"))
	for box in geo["boxes"]:
		var body:=StaticBody3D.new()
		body.collision_layer=1
		body.collision_mask=0
		body.position=Vector3(box["x"],0,box["z"])
		body.rotation_degrees.y=box["rot"]
		var shape:=CollisionShape3D.new()
		var mesh:=BoxShape3D.new()
		mesh.size=Vector3(float(box["hx"])*2,maxf(.5,float(box["height"])),float(box["hz"])*2)
		shape.shape=mesh
		shape.position.y=mesh.size.y*.5
		body.add_child(shape)
		add_child(body)
		collision_count+=1
	if not selected.is_empty() and not state.is_empty():
		player=Player.new()
		add_child(player)
		player.setup(self,selected,state,session_token)
		var mark:=Label3D.new()
		mark.text=String(selected.get("name","Viajante"))
		mark.font_size=32
		mark.pixel_size=.009
		mark.modulate=Color("#d1f9d5")
		mark.billboard=BaseMaterial3D.BILLBOARD_ENABLED
		mark.position=Vector3(0,2.15,0)
		player.add_child(mark)
		player_marker=mark
		focus=player.position
	camera=Camera3D.new()
	camera.projection=Camera3D.PROJECTION_ORTHOGONAL
	camera.near=.08
	camera.current=true
	add_child(camera)
	set_camera_mode(camera_mode)
	print("CW_P05_WORLD_READY placements=",instances," npc=",anchors.size()," exits=",layout["exits"].size())

func make_surface(data:Dictionary)->void:
	var st:=SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var base:=Color(data["color"])
	for face in data["faces"]:
		for idx in face:
			var p:Array=data["vertices"][int(idx)]
			var v:=Vector3(p[0],p[1],p[2])
			var factor:=1.0
			if data["variation"]:factor=.94+.09*sin(v.x*.69+v.z*.37)*cos(v.z*.74)
			st.set_color(Color(base.r*factor,base.g*factor,base.b*factor,1))
			st.add_vertex(v)
	st.generate_normals()
	var m:=StandardMaterial3D.new()
	m.vertex_color_use_as_albedo=true
	m.roughness=.95
	m.cull_mode=BaseMaterial3D.CULL_DISABLED
	var node:=MeshInstance3D.new()
	node.name=data["id"]
	node.mesh=st.commit()
	node.material_override=m
	add_child(node)

func place(p:Dictionary)->Node3D:
	var id:=String(p["asset"])
	var path:="res://world/assets/"+id+".glb"
	if not ResourceLoader.exists(path):path="res://menu_assets/"+id+".glb"
	var scene:=load(path) as PackedScene
	var node:=scene.instantiate() as Node3D
	add_child(node)
	node.position=Vector3(p["x"],p["y"],p["z"])
	node.rotation_degrees.y=p["rotation"]
	node.scale=Vector3.ONE*float(p["scale"])
	if p.has("scale_xyz"):
		var scales:Array=p["scale_xyz"]
		node.scale=Vector3(scales[0],scales[1],scales[2])
	instances+=1
	if p["kind"]=="npc":
		for item in node.find_children("*","AnimationPlayer",true,false):
			var ap:=item as AnimationPlayer
			for clip in ap.get_animation_list():
				if String(clip).to_lower().ends_with("idle"):
					ap.get_animation(clip).loop_mode=Animation.LOOP_LINEAR
					ap.play(clip)
					break
	return node

func add_marker(text:String,pos:Vector3,color:Color,font:int)->void:
	var m:=Label3D.new()
	m.text=text
	m.font_size=font
	m.pixel_size=.012
	m.modulate=color
	m.outline_size=6
	m.billboard=BaseMaterial3D.BILLBOARD_ENABLED
	m.no_depth_test=false
	m.position=pos
	add_child(m)
	markers.append(m)

func release_mouse()->void:
	if look_drag:
		look_drag=false
		Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
func set_camera_mode(mode:int)->void:
	camera_mode=clampi(mode,0,2)
	release_mouse()
	pitch=0.0 if camera_mode==2 else 15.0
	if is_instance_valid(player):
		focus=player.position
		player.visual.visible=camera_mode!=2
		player.target=null
		if is_instance_valid(player_marker):player_marker.visible=camera_mode!=2
	if is_instance_valid(camera):update_camera()
	camera_mode_changed.emit(camera_mode)
func recenter_camera()->void:
	azimuth=25
	zoom=20
	third_distance=5.5
	pitch=0.0 if camera_mode==2 else 15.0
	update_camera()
func update_camera()->void:
	if not is_instance_valid(camera):return
	var r:=deg_to_rad(azimuth)
	var back:=Vector3(sin(r),0,cos(r))
	if camera_mode==0:
		camera.projection=Camera3D.PROJECTION_ORTHOGONAL
		camera.position=focus+back*23+Vector3(0,28,0)
		camera.look_at(focus)
		camera.size=zoom
		return
	camera.projection=Camera3D.PROJECTION_PERSPECTIVE
	camera.fov=75 if camera_mode==2 else 65
	var angle:=deg_to_rad(pitch)
	var forward:=-back*cos(angle)+Vector3.DOWN*sin(angle)
	if camera_mode==2:
		var eye:=player.position+Vector3(0,1.55,0) if is_instance_valid(player) else focus+Vector3(0,1.55,0)
		camera.position=eye
		camera.look_at(eye+forward)
		return
	var pivot:=focus+Vector3(0,1.35,0)
	var desired_position:=pivot-forward*third_distance
	# Cast only against the existing solid world colliders, not the avatar.
	var query:=PhysicsRayQueryParameters3D.create(pivot,desired_position,1)
	var hit:=get_world_3d().direct_space_state.intersect_ray(query)
	if not hit.is_empty():
		var distance:=maxf(.15,pivot.distance_to(hit["position"])-.25)
		desired_position=pivot-forward*distance
	camera.position=desired_position
	camera.look_at(pivot)
func set_focus(pos:Vector3,size_:float)->void:
	focus=pos
	zoom=size_
	update_camera()
func _process(delta:float)->void:
	if not is_instance_valid(camera):return
	if animate:
		elapsed+=delta
		for i in range(boats.size()):
			boats[i].position.y=-.12+sin(elapsed*.8+i)*.08
			boats[i].rotation.z=sin(elapsed*.7+i)*.025
	if not enabled:return
	if is_instance_valid(player):
		focus=focus.lerp(player.position,minf(delta*9,1))
		update_camera()
func _input(event:InputEvent)->void:
	if not enabled or dialog_open:return
	if event is InputEventMouseMotion and look_drag:
		azimuth-=event.relative.x*.18
		if camera_mode!=0:pitch=clampf(pitch+event.relative.y*.16,-65.0,65.0)
		update_camera()
		return
	if event is InputEventMouseButton:
		if event.button_index==MOUSE_BUTTON_RIGHT:
			if event.pressed:
				look_drag=true
				Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
			else:release_mouse()
			return
		if not event.pressed:return
		if event.button_index==MOUSE_BUTTON_WHEEL_UP:
			if camera_mode==0:zoom=maxf(12,zoom-2)
			elif camera_mode==1:third_distance=maxf(2.5,third_distance-.5)
		elif event.button_index==MOUSE_BUTTON_WHEEL_DOWN:
			if camera_mode==0:zoom=minf(35,zoom+2)
			elif camera_mode==1:third_distance=minf(10,third_distance+.5)
		elif event.button_index==MOUSE_BUTTON_LEFT and camera_mode==0 and is_instance_valid(player):
			var area:=get_viewport().get_visible_rect().size
			if event.position.y>100 and event.position.y<area.y-110:
				var ray:=camera.project_ray_origin(event.position)
				var dir:=camera.project_ray_normal(event.position)
				if absf(dir.y)>.001:
					var t:=-ray.y/dir.y
					var point:=ray+dir*t
					var dest:=Vector2(point.x,point.z)
					if t>0 and player.walkable(dest):player.target=dest
		update_camera()
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode==KEY_F5:
			set_camera_mode((camera_mode+1)%3)
			get_viewport().set_input_as_handled()
		elif event.keycode==KEY_ESCAPE:release_mouse()
		elif event.keycode==KEY_Q:azimuth-=15
		elif event.keycode==KEY_E:
			var id:=nearest_npc()
			if id!="":
				npc_requested.emit(id)
				get_viewport().set_input_as_handled()
			else:azimuth+=15
		update_camera()
func _exit_tree()->void:
	release_mouse()
func toggle_markers()->void:
	for m in markers:m.visible=not m.visible


func nearest_npc()->String:
	if not is_instance_valid(player):return ""
	var closest:=""
	var distance:=2.8
	for id in npc_catalog:
		var npc:Dictionary=npc_catalog[id]
		var d:float=player.authority.distance_to(Vector2(npc["x"],npc["z"]))
		if d<=distance:
			distance=d
			closest=id
	return closest

func set_quest_targets(targets:Array)->void:
	for id in npc_markers:
		var npc:Dictionary=npc_catalog[id]
		var mark:Label3D=npc_markers[id]
		mark.text=("! " if id in targets else "")+npc["name"]+" · "+npc["role"]
		mark.modulate=Color("#ffdb80") if id in targets else Color(npc["color"])
