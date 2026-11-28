extends Node3D
## P0.4 world scene, data-driven original art layout. No gameplay interactions.
var layout:Dictionary
var camera:Camera3D
var focus:=Vector3(0,0,0)
var azimuth:=25.0
var zoom:=75.0
var boats:Array[Node3D]=[]
var markers:Array[Label3D]=[]
var anchors:Dictionary={}
var instances:=0
var elapsed:=0.0
var animate:=true
var selected:Dictionary={}
var enabled:=true

func _ready()->void:
	layout=JSON.parse_string(FileAccess.get_file_as_string("res://world/bravamar.json"))
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
			add_marker(p["label"]+" · "+p["role"],model.position+Vector3(0,2.15,0),Color("#fff2c9"),22)
		elif p["kind"]=="building" and p.has("service") and not String(p["service"]).begins_with("home"):
			add_marker(p["label"],model.position+Vector3(0,6.5,0),Color("#e0e5c8"),22)
	for e in layout["exits"]:
		add_marker("↗ "+e["label"]+" · "+e["level"],Vector3(e["x"],2.6,e["z"]),Color("#d4e8b4"),32)
	add_marker("ARENA  ·  PvP futuro",Vector3(0,2.8,-1),Color("#ffd0a1"),34)
	add_marker("Porto de Bravamar",Vector3(7,2.2,25),Color("#e1d7bd"),30)
	if not selected.is_empty():
		var a:=place({"asset":"avatar","x":0,"z":13.8,"y":0,"rotation":180,"scale":1,"kind":"npc"})
		var appearance:Dictionary=selected.get("appearance",{})
		if appearance.get("body")=="sturdy":a.scale=Vector3(1.12,1,1.12)
		if DisplayServer.get_name()!="headless":
			var tint:=Color.WHITE
			if appearance.get("outfit")=="forest":tint=Color("#9ac0a0")
			elif appearance.get("outfit")=="ocean":tint=Color("#9cbce0")
			for mesh in a.find_children("*","MeshInstance3D",true,false):
				var mi:=mesh as MeshInstance3D
				for j in range(mi.mesh.get_surface_count()):
					var original=mi.get_active_material(j)
					if original is StandardMaterial3D:
						var mat:=original.duplicate() as StandardMaterial3D
						mat.albedo_color*=tint
						mi.set_surface_override_material(j,mat)
		add_marker(String(selected.get("name","Viajante")),a.position+Vector3(0,2.4,0),Color("#d1f9d5"),28)
	camera=Camera3D.new()
	camera.projection=Camera3D.PROJECTION_ORTHOGONAL
	camera.current=true
	add_child(camera)
	update_camera()
	print("CW_P04_WORLD_READY placements=",instances," npc=",anchors.size()," exits=",layout["exits"].size())

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

func update_camera()->void:
	var r:=deg_to_rad(azimuth)
	camera.position=focus+Vector3(sin(r)*60,70,cos(r)*60)
	camera.look_at(focus)
	camera.size=zoom
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
	var direction:=Vector2.ZERO
	if Input.is_physical_key_pressed(KEY_W):direction.y-=1
	if Input.is_physical_key_pressed(KEY_S):direction.y+=1
	if Input.is_physical_key_pressed(KEY_A):direction.x-=1
	if Input.is_physical_key_pressed(KEY_D):direction.x+=1
	if direction!=Vector2.ZERO:
		var r:=deg_to_rad(azimuth)
		var movement:=Vector3(direction.x,0,direction.y).rotated(Vector3.UP,r)
		focus+=movement.normalized()*delta*18
		focus.x=clampf(focus.x,-46,46)
		focus.z=clampf(focus.z,-33,34)
		update_camera()
func _input(event:InputEvent)->void:
	if not enabled:return
	if event is InputEventMouseButton and event.pressed:
		if event.button_index==MOUSE_BUTTON_WHEEL_UP:zoom=maxf(12,zoom-5)
		elif event.button_index==MOUSE_BUTTON_WHEEL_DOWN:zoom=minf(80,zoom+5)
		update_camera()
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode==KEY_Q:azimuth-=15
		elif event.keycode==KEY_E:azimuth+=15
		update_camera()
func toggle_markers()->void:
	for m in markers:m.visible=not m.visible
