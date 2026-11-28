extends Node3D
const AvatarVisual=preload("res://avatar_visual.gd")
const COLUMN=preload("res://menu_assets/column.glb")
const ARCH=preload("res://menu_assets/arch.glb")
const BANNER=preload("res://menu_assets/banner.glb")
const PAVER=preload("res://menu_assets/paver.glb")
var camera: Camera3D
var actors: Array[Node3D]=[]
var lights: Array[OmniLight3D]=[]
var positions: Array[Vector3]=[]
var current_slot:=1
var t:=0.0
var reduced_motion:=false

func _ready() -> void:
	var env:=Environment.new()
	env.background_mode=Environment.BG_COLOR
	env.background_color=Color("#152b2d")
	env.ambient_light_source=Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color=Color("#aebdba")
	env.ambient_light_energy=.78
	var we:=WorldEnvironment.new()
	we.environment=env
	add_child(we)
	var sun:=DirectionalLight3D.new()
	sun.rotation_degrees=Vector3(-47,-35,0)
	sun.light_energy=1.2
	sun.light_color=Color("#ffe3ad")
	sun.shadow_enabled=true
	add_child(sun)
	block(Vector3(0,-.25,-.2),Vector3(15,.5,10),Color("#475957"))
	block(Vector3(0,2,-4.5),Vector3(15,4,.35),Color("#344543"))
	for x in [-6.2,-3.1,0,3.1,6.2]:
		place(COLUMN,Vector3(x,0,-3.8))
	for x in [-4.5,-1.5,1.5,4.5]:
		place(ARCH,Vector3(x,0,-3.7))
	for x in [-5.5,5.5]:
		place(BANNER,Vector3(x,1.5,-4.1))
	for i in range(5):
		var p:=Vector3((i-2)*2.45,0,-abs(i-2)*.35)
		positions.append(p)
		block(p+Vector3(0,.13,0),Vector3(1.95,.26,1.95),Color("#64736b"))
		for dx in [-.42,.42]:
			for dz in [-.42,.42]:
				place(PAVER,p+Vector3(dx,.27,dz))
		var mark:=Label3D.new()
		mark.text="%02d"%(i+1)
		mark.font_size=40
		mark.pixel_size=.009
		mark.modulate=Color("#e8cb8a")
		mark.position=p+Vector3(0,.48,.99)
		add_child(mark)
		var light:=OmniLight3D.new()
		light.position=p+Vector3(0,2,1.1)
		light.light_color=Color("#ffd08a")
		light.omni_range=4.0
		light.light_energy=.1
		add_child(light)
		lights.append(light)
		actors.append(null)
	camera=Camera3D.new()
	camera.current=true
	camera.fov=42
	add_child(camera)
	camera.position=Vector3(0,4.1,12.8)
	camera.look_at(Vector3(0,1.25,-.5))

func block(pos:Vector3,sz:Vector3,color:Color)->void:
	var n:=MeshInstance3D.new()
	var mesh:=BoxMesh.new()
	mesh.size=sz
	var m:=StandardMaterial3D.new()
	m.albedo_color=color
	m.roughness=.93
	mesh.material=m
	n.mesh=mesh
	add_child(n)
	n.position=pos

func place(scene:PackedScene,pos:Vector3)->Node3D:
	var n:Node3D=scene.instantiate()
	add_child(n)
	n.position=pos
	return n

func render_roster(slots:Array,focus:int,preview:Dictionary={}) -> void:
	current_slot=focus
	for i in range(5):
		if actors[i]!=null:
			actors[i].queue_free()
			actors[i]=null
		var data:Variant=slots[i] if i<slots.size() else null
		if i+1==focus and not preview.is_empty():
			data={"appearance":preview}
		if data is Dictionary:
			var a:=AvatarVisual.create(data.get("appearance",{}))
			add_child(a)
			a.position=positions[i]+Vector3(0,.35,0)
			actors[i]=a
			AvatarVisual.play(a,"Idle")
		lights[i].light_energy=2.3 if i+1==focus else .25

func _process(delta:float)->void:
	if not is_instance_valid(camera):return
	if not reduced_motion:t+=delta
	var target:=positions[current_slot-1] if positions.size()==5 else Vector3.ZERO
	var sway:=sin(t*.25)*.15 if not reduced_motion else 0.0
	var desired:=Vector3(target.x*.63+sway,3.0,8.4)
	camera.position=camera.position.lerp(desired,minf(delta*4,1.0))
	camera.look_at(Vector3(target.x*.65,1.25,-.4))
