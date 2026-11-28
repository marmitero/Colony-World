extends RefCounted
const MODEL=preload("res://world/assets/avatar_custom.glb")
static func create(a:Dictionary)->Node3D:
	var n:=MODEL.instantiate() as Node3D
	apply(n,a)
	return n
static func apply(n:Node3D,a:Dictionary)->void:
	n.scale=Vector3(1.12,1,1.12) if a.get("body")=="sturdy" else Vector3.ONE
	var outfit:=Color.WHITE
	if a.get("outfit")=="forest":outfit=Color("#95c19a")
	elif a.get("outfit")=="ocean":outfit=Color("#9dbde6")
	var skin:=Color.WHITE
	if a.get("skin")=="warm":skin=Color("#e2ba91")
	elif a.get("skin")=="deep":skin=Color("#986c52")
	var hair_color:=Color("#70462c")
	if a.get("hair_color")=="black":hair_color=Color("#292728")
	elif a.get("hair_color")=="copper":hair_color=Color("#b76e39")
	var hairstyle:=String(a.get("hair","classic"))
	if hairstyle=="":hairstyle="classic"
	for o in n.find_children("*","MeshInstance3D",true,false):
		var mi:=o as MeshInstance3D
		var name_:=String(mi.name).to_lower().replace(".","_")
		if name_.contains("cw_hair_"):
			mi.visible=name_.ends_with(hairstyle) and hairstyle!="classic"
		if name_=="monk_001":
			mi.scale.x=.93 if a.get("face")=="angular" else 1.0
		if DisplayServer.get_name()=="headless":continue
		for i in range(mi.mesh.get_surface_count()):
			var original=mi.get_active_material(i)
			if original is StandardMaterial3D:
				var m:=original.duplicate() as StandardMaterial3D
				var mat_name:=String(original.resource_name).to_lower()
				if mat_name.contains("cw_hair"):m.albedo_color=hair_color
				elif mat_name.contains("cw_skin"):m.albedo_color*=skin
				elif mat_name.contains("cw_outfit"):m.albedo_color*=outfit
				mi.set_surface_override_material(i,m)
static func play(n:Node3D,clip:String,blend:float=.15)->void:
	for o in n.find_children("*","AnimationPlayer",true,false):
		var ap:=o as AnimationPlayer
		if ap.has_animation(clip):
			ap.get_animation(clip).loop_mode=Animation.LOOP_LINEAR
			if ap.current_animation!=clip:ap.play(clip,blend)
