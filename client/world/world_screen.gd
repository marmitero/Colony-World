extends Control
const Bravamar=preload("res://world/bravamar.gd")
var village:Node3D
var app:Control
func setup(parent:Control,character:Dictionary)->void:
	app=parent
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	village=Bravamar.new()
	village.selected=character
	village.animate=not app.reduced_motion
	add_child(village)
	var top:=MarginContainer.new()
	top.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	top.add_theme_constant_override("margin_left",22)
	top.add_theme_constant_override("margin_right",22)
	top.add_theme_constant_override("margin_top",18)
	add_child(top)
	var panel:=PanelContainer.new()
	var style:=StyleBoxFlat.new()
	style.bg_color=Color(0.07,.14,.12,.92)
	style.set_corner_radius_all(8)
	style.content_margin_left=14
	style.content_margin_right=14
	style.content_margin_top=10
	style.content_margin_bottom=10
	panel.add_theme_stylebox_override("panel",style)
	top.add_child(panel)
	var row:=HBoxContainer.new()
	row.add_theme_constant_override("separation",12)
	panel.add_child(row)
	var titlebox:=VBoxContainer.new()
	titlebox.size_flags_horizontal=Control.SIZE_EXPAND_FILL
	row.add_child(titlebox)
	titlebox.add_child(app.label("BRAVAMAR  /  VILA INICIAL",22,Color("#ead2a3")))
	titlebox.add_child(app.label("P0.4 • visita artística • zona segura fora da arena",13))
	var back:Button=app.button("Voltar aos personagens")
	back.pressed.connect(app.close_world_preview)
	row.add_child(back)
	var bottom:=MarginContainer.new()
	bottom.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	bottom.add_theme_constant_override("margin_left",22)
	bottom.add_theme_constant_override("margin_right",22)
	bottom.add_theme_constant_override("margin_bottom",18)
	add_child(bottom)
	var tools:=PanelContainer.new()
	tools.add_theme_stylebox_override("panel",style)
	bottom.add_child(tools)
	var box:=VBoxContainer.new()
	tools.add_child(box)
	box.add_child(app.label("WASD: mover câmera  •  Q/E: girar  •  Rodinha: zoom  •  Sem movimentação de avatar nesta etapa",14))
	var buttons:=HBoxContainer.new()
	box.add_child(buttons)
	for entry in [["Visão geral",Vector3(0,0,0),75.0],["Praça",Vector3(0,0,-1),24.0],["Mercado",Vector3(-23,0,8),23.0],["Forja",Vector3(24,0,-11),23.0],["Porto",Vector3(10,0,24),24.0]]:
		var button_:Button=app.button(entry[0])
		button_.pressed.connect(func():village.set_focus(entry[1],entry[2]))
		buttons.add_child(button_)
	var marker:Button=app.button("Rótulos")
	marker.pressed.connect(village.toggle_markers)
	buttons.add_child(marker)
