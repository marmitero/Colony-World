extends Control
const Bravamar=preload("res://world/bravamar.gd")
var village:Node3D
var app:Control
var status:Label
var zone_label:Label
var camera_choice:OptionButton
var settings_panel:PanelContainer
var control_hint:Label
var quest:Dictionary={}
var quest_http:HTTPRequest
var quest_busy:=false
var request_kind:=""
var active_npc:=""
var quest_label:Label
var prompt_label:Label
var talk_button:Button
var dialog_panel:PanelContainer
var dialog_title:Label
var dialog_bio:Label
var dialog_text:Label
var choices:VBoxContainer
var journal_panel:PanelContainer
var journal_text:Label
func setup(parent:Control,character:Dictionary,state:Dictionary)->void:
	app=parent
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	village=Bravamar.new()
	village.selected=character
	village.state=state
	village.session_token=app.session_token
	village.camera_mode=app.camera_mode
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
	quest_label=app.label("Carregando missão…",14,Color("#ffdb80"))
	titlebox.add_child(quest_label)
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
	control_hint=app.label("",14)
	box.add_child(control_hint)
	var buttons:=HBoxContainer.new()
	box.add_child(buttons)
	var recenter:Button=app.button("Centralizar câmera")
	recenter.pressed.connect(village.recenter_camera)
	buttons.add_child(recenter)
	status=app.label("Servidor conectado",14,Color("#a8d89b"))
	buttons.add_child(status)
	talk_button=app.button("Conversar (E)")
	talk_button.disabled=true
	talk_button.pressed.connect(func():interact(village.nearest_npc()))
	buttons.add_child(talk_button)
	var journal:Button=app.button("Diário (J)")
	buttons.add_child(journal)
	journal.pressed.connect(toggle_journal)
	prompt_label=app.label("",14,Color("#ffdb80"))
	box.add_child(prompt_label)
	village.player.state_changed.connect(update_status)
	village.player.session_lost.connect(app.close_world_preview)
	var marker:Button=app.button("Rótulos")
	marker.pressed.connect(village.toggle_markers)
	buttons.add_child(marker)
	var settings_button:Button=app.button("Configurações")
	buttons.add_child(settings_button)
	settings_panel=PanelContainer.new()
	settings_panel.add_theme_stylebox_override("panel",style)
	settings_panel.visible=false
	var settings_box:=VBoxContainer.new()
	settings_panel.add_child(settings_box)
	settings_box.add_child(app.label("Visão do jogo (F5)",16,Color("#ead2a3")))
	camera_choice=OptionButton.new()
	for name_ in ["Visão superior","Terceira pessoa","Primeira pessoa"]:camera_choice.add_item(name_)
	camera_choice.select(village.camera_mode)
	camera_choice.item_selected.connect(func(mode):village.set_camera_mode(mode))
	settings_box.add_child(camera_choice)
	settings_box.add_child(app.label("Segure o botão direito para olhar. Solte ou aperte Esc para liberar o mouse.",13))
	box.add_child(settings_panel)
	settings_button.pressed.connect(func():village.release_mouse();settings_panel.visible=not settings_panel.visible)
	village.camera_mode_changed.connect(on_camera_mode)
	on_camera_mode(village.camera_mode)
	build_quest_ui(style)
	village.npc_requested.connect(interact)
	quest_http=HTTPRequest.new()
	quest_http.timeout=6
	add_child(quest_http)
	quest_http.request_completed.connect(quest_response)
	send_quest("quest","/v1/world/quests",HTTPClient.METHOD_GET,"")
	update_status()


func update_status()->void:
	zone_label.text="Arena • PvP aguardando implementação" if village.player.zone=="arena_future" else "Zona segura"
	status.text="Servidor conectado" if village.player.online else "Conexão interrompida • volte ao salão"
	if talk_button!=null:
		var id:String=village.nearest_npc()
		talk_button.disabled=id=="" or quest_busy or village.dialog_open
		prompt_label.text="E · conversar com "+village.npc_catalog[id]["name"] if id!="" else "Aproxime-se de um NPC para conversar."

func on_camera_mode(mode:int)->void:
	app.set_camera_preference(mode)
	camera_choice.select(mode)
	control_hint.text="F5: trocar visão  •  WASD / clique: mover  •  Shift: correr  •  Q/E: girar (E perto de NPC: falar)  •  Rodinha: zoom" if mode==0 else "F5: trocar visão  •  WASD: mover  •  Shift: correr  •  Botão direito + mouse: olhar  •  Q/E: girar (E perto de NPC: falar)"

func build_quest_ui(style:StyleBoxFlat)->void:
	dialog_panel=PanelContainer.new()
	dialog_panel.add_theme_stylebox_override("panel",style)
	add_child(dialog_panel)
	dialog_panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	dialog_panel.offset_left=-300
	dialog_panel.offset_right=300
	dialog_panel.offset_top=-180
	var box:=VBoxContainer.new()
	box.add_theme_constant_override("separation",10)
	dialog_panel.add_child(box)
	dialog_title=app.label("",24,Color("#ead2a3"))
	box.add_child(dialog_title)
	dialog_bio=app.label("",15,Color("#a8d89b"))
	box.add_child(dialog_bio)
	dialog_text=app.label("",17)
	dialog_text.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
	dialog_text.custom_minimum_size=Vector2(560,100)
	box.add_child(dialog_text)
	choices=VBoxContainer.new()
	box.add_child(choices)
	var close:Button=app.button("Encerrar conversa (Esc)")
	close.pressed.connect(close_dialog)
	box.add_child(close)
	dialog_panel.hide()
	journal_panel=PanelContainer.new()
	journal_panel.add_theme_stylebox_override("panel",style)
	add_child(journal_panel)
	journal_panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	journal_panel.offset_left=-280
	journal_panel.offset_right=280
	journal_panel.offset_top=-160
	var jbox:=VBoxContainer.new()
	journal_panel.add_child(jbox)
	jbox.add_child(app.label("DIÁRIO DE AVENTURA",22,Color("#ead2a3")))
	journal_text=app.label("",17)
	journal_text.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
	journal_text.custom_minimum_size=Vector2(510,150)
	jbox.add_child(journal_text)
	var done:Button=app.button("Fechar diário (J)")
	done.pressed.connect(toggle_journal)
	jbox.add_child(done)
	journal_panel.hide()

func _input(event:InputEvent)->void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode==KEY_ESCAPE and village.dialog_open and not quest_busy:
			close_dialog()
			get_viewport().set_input_as_handled()
		elif event.keycode==KEY_J and not village.dialog_open:
			toggle_journal()
			get_viewport().set_input_as_handled()

func toggle_journal()->void:
	if village.dialog_open:return
	village.release_mouse()
	journal_panel.visible=not journal_panel.visible
	village.player.interaction_locked=journal_panel.visible
	# Prevent click-to-move behind the journal.
	village.enabled=not journal_panel.visible

func interact(id:String,action:String="talk")->void:
	if quest_busy or id=="" or journal_panel.visible:return
	active_npc=id
	village.release_mouse()
	village.dialog_open=true
	village.player.interaction_locked=true
	send_quest("interact","/v1/world/interact",HTTPClient.METHOD_POST,JSON.stringify({"npc_id":id,"action":action}))

func send_quest(kind:String,path:String,method:HTTPClient.Method,body:String)->void:
	quest_busy=true
	request_kind=kind
	var error:=quest_http.request("http://127.0.0.1:3000"+path,PackedStringArray(["Authorization: Bearer "+app.session_token,"Content-Type: application/json"]),method,body)
	if error!=OK:
		quest_busy=false
		close_dialog()
		quest_label.text="Não foi possível consultar o servidor."

func quest_response(result:int,code:int,_headers:PackedStringArray,body:PackedByteArray)->void:
	quest_busy=false
	var data:Variant=JSON.parse_string(body.get_string_from_utf8())
	if result!=HTTPRequest.RESULT_SUCCESS or code!=200 or not data is Dictionary:
		close_dialog()
		quest_label.text="Aproxime-se do NPC e tente novamente." if data is Dictionary and data.get("error")=="npc_too_far" else "Não foi possível concluir a interação. Tente novamente."
		return
	quest=data if request_kind=="quest" else data["quest"]
	refresh_quest()
	if request_kind=="interact":
		var npc:Dictionary=data["npc"]
		dialog_title.text=npc["name"]+" · "+npc["role"]
		dialog_bio.text=npc["bio"]
		dialog_text.text=npc["dialog"]+("

"+data["text"] if data["text"]!="" else "")
		for child in choices.get_children():
			choices.remove_child(child)
			child.queue_free()
		for choice in data["choices"]:
			var action:String=choice["action"]
			var button:Button=app.button(choice["label"],action!="pause")
			button.pressed.connect(func():interact(active_npc,action))
			choices.add_child(button)
		dialog_panel.show()
	update_status()

func refresh_quest()->void:
	quest_label.text=str(quest["completed"])+"/3  ·  "+quest["title"]
	village.set_quest_targets(quest["targets"])
	var lines:=PackedStringArray()
	for id in quest["targets"]:
		lines.append(village.npc_catalog[id]["name"])
	journal_text.text=quest["title"]+"  ("+str(quest["completed"])+"/3)

"+quest["objective"]
	if not lines.is_empty():journal_text.text+="

Procure: "+", ".join(lines)
	if quest["progress"]["land_deed_unlocked"]:journal_text.text+="

Escritura: elegibilidade liberada (residência futura)."

func close_dialog()->void:
	if quest_busy:return
	dialog_panel.hide()
	active_npc=""
	village.dialog_open=false
	village.player.interaction_locked=false
	update_status()
