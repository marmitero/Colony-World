extends Control
const Bravamar=preload("res://world/bravamar.gd")
var village:Node3D
var app:Control
var status:Label
var zone_label:Label
func setup(parent:Control,character:Dictionary,state:Dictionary)->void:
	app=parent
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	village=Bravamar.new()
	village.selected=character
	village.state=state
	village.session_token=app.session_token
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
	titlebox.add_child(app.label(String(character.get("name"))+"  •  Nível "+str(character.get("level"))+"  •  "+str(character.get("gold"))+" G",14))
	zone_label=app.label("Zona segura",14,Color("#a8d89b"))
	titlebox.add_child(zone_label)
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
	box.add_child(app.label("WASD / clique no chão: mover  •  Shift: correr  •  Q/E: girar câmera  •  Rodinha: zoom",14))
	var buttons:=HBoxContainer.new()
	box.add_child(buttons)
	var recenter:Button=app.button("Centralizar câmera")
	recenter.pressed.connect(func():village.azimuth=25;village.zoom=20;village.update_camera())
	buttons.add_child(recenter)
	status=app.label("Servidor conectado",14,Color("#a8d89b"))
	buttons.add_child(status)
	village.player.state_changed.connect(update_status)
	village.player.session_lost.connect(app.close_world_preview)
	var marker:Button=app.button("Rótulos")
	marker.pressed.connect(village.toggle_markers)
	buttons.add_child(marker)

func update_status()->void:
	zone_label.text="Arena • PvP aguardando implementação" if village.player.zone=="arena_future" else "Zona segura"
	status.text="Servidor conectado" if village.player.online else "Conexão interrompida • volte ao salão"
