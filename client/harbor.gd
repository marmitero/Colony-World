extends Node3D
## Original animated menu backdrop. This is not the playable Bravamar map.
const MODELS := {
	"house": preload("res://menu_assets/house.glb"),
	"market": preload("res://menu_assets/market.glb"),
	"well": preload("res://menu_assets/well.glb"),
	"crate": preload("res://menu_assets/crate.glb"),
	"cart": preload("res://menu_assets/cart.glb"),
	"tree": preload("res://menu_assets/tree.glb"),
	"rock": preload("res://menu_assets/rock.glb"),
	"grass": preload("res://menu_assets/grass.glb"),
	"fence": preload("res://menu_assets/fence.glb"),
	"paver": preload("res://menu_assets/paver.glb"),
	"avatar": preload("res://menu_assets/avatar.glb"),
	"boat": preload("res://menu_assets/boat.glb"),
}
var camera: Camera3D
var boats: Array[Node3D] = []
var elapsed := 0.0
var drift_enabled := true
var lanterns: Array[OmniLight3D] = []

func _ready() -> void:
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color("#293c4b")
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color("#9fb1c6")
	env.ambient_light_energy = 0.65
	env.fog_enabled = true
	env.fog_light_color = Color("#6b7681")
	env.fog_density = 0.009
	var world := WorldEnvironment.new()
	world.environment = env
	add_child(world)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-26, -48, 0)
	sun.light_color = Color("#ffd2a0")
	sun.light_energy = 1.3
	sun.shadow_enabled = true
	add_child(sun)
	# Coast, sandy quay, sea. Meshes are terrain supports, not gameplay props.
	block(Vector3(-8, -0.25, -5), Vector3(25, 0.5, 20), Color("#536b47"))
	block(Vector3(-7, -0.10, 5.0), Vector3(24, 0.2, 4.0), Color("#9a805c"))
	block(Vector3(-4, -0.07, 8.6), Vector3(9.7, 0.36, 4.4), Color("#64482e"))
	for n in range(19):
		block(Vector3(-8.5+n*.5, 0.16, 8.6), Vector3(.46,.08,4.3), Color("#997151") if n%3==0 else Color("#785539"))
	var sea := MeshInstance3D.new()
	var plane := PlaneMesh.new()
	plane.size = Vector2(100,100)
	plane.subdivide_width = 60
	plane.subdivide_depth = 60
	sea.mesh = plane
	var water := ShaderMaterial.new()
	water.shader = preload("res://water.gdshader")
	sea.material_override = water
	sea.position = Vector3(0,-0.25,30)
	add_child(sea)
	var placements := [
		["house", -12, -4, 12], ["house", -5, -6, 28], ["house", 1, -8, -23],
		["market",-6,-1,0],["well",-1,-2,12],["cart",-9,1,24],
		["crate",-5,3,0],["crate",-4,2,40],["crate",-9,5,15],
		["avatar",-2,2,15],["tree",-15,-8,0],["tree",-9,-11,44],
		["tree",3,-10,30],["tree",-15,0,60],["rock",-13,4,60],
		["rock",2,5,15],["rock",3,5,80],["fence",-10,5,0],["fence",-7.5,5,0]
	]
	for a in placements:
		place(a[0],Vector3(a[1],0,a[2]),a[3])
	for row in range(3):
		for col in range(10):
			place("paver",Vector3(-10+col*.8,0.015,1+row*.8),0)
	for i in range(20):
		place("grass",Vector3(-14+float(i%10)*1.3,0,-2.7-float(i/10)*3),i*33)
	for point in [Vector3(-7,0.3,12.0),Vector3(0,0.25,10.0)]:
		var b := place("boat",point, -25 if boats.is_empty() else 35)
		boats.append(b)
	for p in [Vector3(-12,2,0),Vector3(-6,2,0),Vector3(-2,1.7,3),Vector3(-9,1.5,8)]:
		var light := OmniLight3D.new()
		light.position = p
		light.light_color = Color("#ffb66b")
		light.light_energy = 2
		light.omni_range = 5
		add_child(light)
		lanterns.append(light)
	camera = Camera3D.new()
	camera.fov = 48
	camera.current = true
	add_child(camera)
	update_camera()

func block(pos: Vector3, size_: Vector3, color: Color) -> void:
	var n := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = size_
	var m := StandardMaterial3D.new()
	m.albedo_color = color
	m.roughness = .97
	box.material = m
	n.mesh = box
	n.position = pos
	add_child(n)
func place(id: String, pos: Vector3, rot: float) -> Node3D:
	var n: Node3D = MODELS[id].instantiate()
	add_child(n)
	n.position = pos
	n.rotation_degrees.y = rot
	for child in n.find_children("*","AnimationPlayer",true,false):
		var a := child as AnimationPlayer
		for clip in a.get_animation_list():
			if String(clip).to_lower().ends_with("idle"):
				a.get_animation(clip).loop_mode = Animation.LOOP_LINEAR
				a.play(clip)
				break
	return n
func update_camera() -> void:
	camera.position = Vector3(8.2+sin(elapsed*.14)*1.8, 9.5+sin(elapsed*.11)*.6, 19+cos(elapsed*.10)*1.2)
	camera.look_at(Vector3(-4.6,1.8,0))
func _process(delta: float) -> void:
	if not drift_enabled: return
	elapsed += delta
	update_camera()
	for i in range(boats.size()):
		boats[i].position.y = .15+sin(elapsed*1.05+i*1.6)*.12
		boats[i].rotation.z = sin(elapsed*.85+i)*.035
	for i in range(lanterns.size()):
		lanterns[i].light_energy = 1.8+sin(elapsed*3.1+i)*.2
