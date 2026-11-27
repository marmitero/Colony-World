extends Node3D
## P00 Only — no gameplay or networking. Camera inspection of imported assets.
var cam: Camera3D
var angle := -25.0
var zoom := 36.0
var playing := true
var animators: Array[AnimationPlayer] = []
var stats: Label
var instances := 0
const MODELS := {
	"avatar": preload("res://assets/avatar.glb"), "merchant": preload("res://assets/merchant.glb"),
	"slime": preload("res://assets/slime.glb"), "skeleton": preload("res://assets/skeleton.glb"),
	"deer": preload("res://assets/deer.glb"), "cow": preload("res://assets/cow.glb"),
	"chicken": preload("res://assets/chicken.glb"), "house": preload("res://assets/house.glb"),
	"market": preload("res://assets/market.glb"), "fence": preload("res://assets/fence.glb"),
	"well": preload("res://assets/well.glb"), "crate": preload("res://assets/crate.glb"),
	"wheat": preload("res://assets/wheat.glb"), "tree": preload("res://assets/tree.glb"),
	"rock": preload("res://assets/rock.glb"), "axe": preload("res://assets/axe.glb"),
	"pickaxe": preload("res://assets/pickaxe.glb"), "potion": preload("res://assets/potion.glb"),
	"cart": preload("res://assets/cart.glb"),
	"grass": preload("res://assets/grass.glb"), "paver": preload("res://assets/paver.glb"),
}
func _ready() -> void:
	var data: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://layout.json"))
	block(Vector3(0, -0.2, 0), Vector3(32, 0.4, 24), Color("#779759"))
	var idx := 0
	for p in data["paths"]:
		block(Vector3(p[0], 0.008 + idx * 0.001, -p[1]), Vector3(p[2], 0.016, p[3]), Color("#835c3c") if idx == 3 else Color("#bea17a"))
		idx += 1
	for p in data["placements"]:
		var node: Node3D = MODELS[p[0]].instantiate()
		node.name = p[0] + "_" + str(instances)
		add_child(node)
		node.position = Vector3(p[1], p[3], -p[2])
		node.rotation_degrees.y = p[4]
		instances += 1
		for a in node.find_children("*", "AnimationPlayer", true, false):
			var player := a as AnimationPlayer
			animators.append(player)
			for name_ in player.get_animation_list():
				if String(name_).to_lower().ends_with("idle"):
					player.get_animation(name_).loop_mode = Animation.LOOP_LINEAR
					player.play(name_)
					break
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color("#b7ccd7")
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color("#c5d8e3")
	env.ambient_light_energy = 0.75
	var we := WorldEnvironment.new()
	we.environment = env
	add_child(we)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-52, -35, 0)
	sun.light_energy = 1.15
	sun.shadow_enabled = true
	add_child(sun)
	cam = Camera3D.new()
	cam.projection = Camera3D.PROJECTION_ORTHOGONAL
	cam.current = true
	add_child(cam)
	update_camera()
	var layer := CanvasLayer.new()
	add_child(layer)
	var panel := PanelContainer.new()
	panel.position = Vector2(20, 20)
	layer.add_child(panel)
	var box := VBoxContainer.new()
	panel.add_child(box)
	var title := Label.new()
	title.text = "COLONY WORLD  /  P00 — BRAVAMAR"
	title.add_theme_font_size_override("font_size", 21)
	box.add_child(title)
	stats = Label.new()
	box.add_child(stats)
	update_stats()
	print("P00_OK models=", MODELS.size(), " instances=", instances, " animation_players=", animators.size())
func block(pos: Vector3, sz: Vector3, color: Color) -> void:
	var n := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = sz
	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	mat.roughness = 0.95
	mesh.material = mat
	n.mesh = mesh
	add_child(n)
	n.position = pos
func update_camera() -> void:
	var r := deg_to_rad(angle)
	cam.position = Vector3(sin(r) * 31, 32, cos(r) * 31)
	cam.look_at(Vector3.ZERO)
	cam.size = zoom
func update_stats() -> void:
	stats.text = "%d modelos · %d instâncias · %d animadores\n← → girar · ↑ ↓ zoom · Espaço pausa/resume" % [MODELS.size(), instances, animators.size()]
func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_LEFT: angle -= 15
			KEY_RIGHT: angle += 15
			KEY_UP: zoom = maxf(16.0, zoom - 2)
			KEY_DOWN: zoom = minf(48.0, zoom + 2)
			KEY_SPACE:
				playing = not playing
				for a in animators: a.speed_scale = 1.0 if playing else 0.0
		update_camera()
