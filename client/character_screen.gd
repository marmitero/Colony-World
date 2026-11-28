extends Control
const Hall=preload("res://character_hall.gd")
var app: Control
var hall: Node3D
var slots:Array=[null,null,null,null,null]
var selected_id:=""
var focus_slot:=1
var slot_buttons:Array[Button]=[]
var name_field:LineEdit
var body_choice:OptionButton
var outfit_choice:OptionButton
var face_choice:OptionButton
var skin_choice:OptionButton
var hair_choice:OptionButton
var hair_color_choice:OptionButton
var editing:=false
var edit_button:Button
var cancel_edit:Button
var form:VBoxContainer
var details:VBoxContainer
var heading:Label
var info:Label
var feedback:Label
var choose:Button
var enter_world:Button
var delete_button:Button
var cancel_delete:Button
var create_button:Button
var delete_dialog:ConfirmationDialog
var back:Button

func setup(parent:Control)->void:
	app=parent
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var bg:=ColorRect.new()
	bg.color=Color("#142421")
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	var margin:=MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for side in ["left","right","top","bottom"]:
		margin.add_theme_constant_override("margin_"+side,24)
	add_child(margin)
	var outer:=VBoxContainer.new()
	margin.add_child(outer)
	var top:=HBoxContainer.new()
	outer.add_child(top)
	top.add_child(app.label("COLONY WORLD  /  SALÃO DOS VIAJANTES",20,Color("#e3c28a")))
	var sp:=Control.new()
	sp.size_flags_horizontal=Control.SIZE_EXPAND_FILL
	top.add_child(sp)
	back=app.button("Sair da conta")
	back.pressed.connect(app.logout)
	top.add_child(back)
	var row:=HBoxContainer.new()
	row.size_flags_vertical=Control.SIZE_EXPAND_FILL
	row.add_theme_constant_override("separation",18)
	outer.add_child(row)
	var left:=VBoxContainer.new()
	left.size_flags_horizontal=Control.SIZE_EXPAND_FILL
	row.add_child(left)
	var viewport_container:=SubViewportContainer.new()
	viewport_container.stretch=true
	viewport_container.size_flags_vertical=Control.SIZE_EXPAND_FILL
	viewport_container.custom_minimum_size=Vector2(360,300)
	left.add_child(viewport_container)
	var viewport:=SubViewport.new()
	viewport.own_world_3d=true
	viewport.render_target_update_mode=SubViewport.UPDATE_ALWAYS
	viewport.size=Vector2i(640,430)
	viewport_container.add_child(viewport)
	hall=Hall.new()
	hall.reduced_motion=app.reduced_motion
	viewport.add_child(hall)
	left.add_child(app.label("Bravamar  •  Escolha seu próximo viajante",18))
	left.add_child(app.label("Sem classes fixas. Sua jornada define sua profissão.",14,Color("#afc0b3")))
	var right:=PanelContainer.new()
	right.custom_minimum_size.x=365
	var style:=StyleBoxFlat.new()
	style.bg_color=Color("#1d322a")
	style.border_color=Color("#a88c5c")
	style.set_border_width_all(1)
	style.set_corner_radius_all(10)
	style.content_margin_left=18
	style.content_margin_right=18
	style.content_margin_top=14
	style.content_margin_bottom=14
	right.add_theme_stylebox_override("panel",style)
	row.add_child(right)
	var scroll:=ScrollContainer.new()
	scroll.horizontal_scroll_mode=ScrollContainer.SCROLL_MODE_DISABLED
	right.add_child(scroll)
	var list:=VBoxContainer.new()
	list.size_flags_horizontal=Control.SIZE_EXPAND_FILL
	list.add_theme_constant_override("separation",5)
	scroll.add_child(list)
	heading=app.label("Seus personagens",24)
	list.add_child(heading)
	for i in range(5):
		var b:Button=app.button("")
		b.custom_minimum_size.y=34
		b.pressed.connect(func():focus(i+1))
		list.add_child(b)
		slot_buttons.append(b)
	form=VBoxContainer.new()
	form.add_theme_constant_override("separation",4)
	list.add_child(form)
	name_field=app.field("Nome: 3–20 caracteres")
	name_field.max_length=20
	name_field.custom_minimum_size.y=34
	form.add_child(name_field)
	body_choice=OptionButton.new()
	body_choice.add_item("Corpo • Padrão")
	body_choice.add_item("Corpo • Robusto")
	var grid:=GridContainer.new()
	grid.columns=2
	grid.add_theme_constant_override("h_separation",6)
	grid.add_theme_constant_override("v_separation",4)
	form.add_child(grid)
	grid.add_child(body_choice)
	outfit_choice=OptionButton.new()
	outfit_choice.add_item("Paleta • Terra")
	outfit_choice.add_item("Paleta • Floresta")
	outfit_choice.add_item("Paleta • Oceano")
	grid.add_child(outfit_choice)
	face_choice=option(["Rosto • Oval","Rosto • Angular"],grid)
	skin_choice=option(["Pele • Natural","Pele • Quente","Pele • Profunda"],grid)
	hair_choice=option(["Cabelo • Clássico","Cabelo • Curto","Cabelo • Lateral"],grid)
	hair_color_choice=option(["Cor • Castanho","Cor • Preto","Cor • Cobre"],grid)
	hair_choice.select(1)
	hair_color_choice.disabled=false
	body_choice.item_selected.connect(func(_x):refresh_preview())
	outfit_choice.item_selected.connect(func(_x):refresh_preview())
	create_button=app.button("Criar personagem",true)
	create_button.pressed.connect(create_character)
	form.add_child(create_button)
	cancel_edit=app.button("Cancelar edição")
	cancel_edit.pressed.connect(func():editing=false;refresh())
	form.add_child(cancel_edit)
	details=VBoxContainer.new()
	details.add_theme_constant_override("separation",4)
	list.add_child(details)
	info=app.label("",14,Color("#d4d9c8"))
	info.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
	details.add_child(info)
	choose=app.button("Selecionar personagem",true)
	choose.pressed.connect(func():change("select"))
	details.add_child(choose)
	enter_world=app.button("Entrar em Bravamar",true)
	enter_world.pressed.connect(func():app.open_world_preview(slots[focus_slot-1]))
	details.add_child(enter_world)
	edit_button=app.button("Personalizar aparência")
	edit_button.pressed.connect(begin_edit)
	details.add_child(edit_button)
	delete_button=app.button("Solicitar exclusão")
	delete_button.pressed.connect(func():delete_dialog.popup_centered())
	details.add_child(delete_button)
	cancel_delete=app.button("Cancelar exclusão")
	cancel_delete.pressed.connect(func():change("cancel_delete"))
	details.add_child(cancel_delete)
	feedback=app.label("",14,Color("#e9c68d"))
	feedback.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
	list.add_child(feedback)
	delete_dialog=ConfirmationDialog.new()
	delete_dialog.title="Agendar exclusão"
	delete_dialog.dialog_text="A exclusão acontecerá depois de 72 horas. Você poderá cancelar até lá."
	delete_dialog.ok_button_text="Agendar"
	delete_dialog.confirmed.connect(func():change("delete"))
	add_child(delete_dialog)
	refresh()

func option(values:Array,grid:GridContainer)->OptionButton:
	var o:=OptionButton.new()
	for v in values:o.add_item(v)
	o.size_flags_horizontal=Control.SIZE_EXPAND_FILL
	grid.add_child(o)
	o.item_selected.connect(func(_x):refresh_preview())
	return o
func appearance()->Dictionary:
	return {"body":["standard","sturdy"][body_choice.selected],"outfit":["earth","forest","ocean"][outfit_choice.selected],"face":["oval","angular"][face_choice.selected],"skin":["natural","warm","deep"][skin_choice.selected],"hair":["classic","short","swept"][hair_choice.selected],"hair_color":["brown","black","copper"][hair_color_choice.selected]}
func begin_edit()->void:
	var a:Dictionary=slots[focus_slot-1].get("appearance",{})
	editing=true
	body_choice.select(maxi(0,["standard","sturdy"].find(a.get("body"))))
	outfit_choice.select(maxi(0,["earth","forest","ocean"].find(a.get("outfit"))))
	face_choice.select(maxi(0,["oval","angular"].find(a.get("face"))))
	skin_choice.select(maxi(0,["natural","warm","deep"].find(a.get("skin"))))
	hair_choice.select(maxi(0,["classic","short","swept"].find(a.get("hair"))))
	hair_color_choice.select(maxi(0,["brown","black","copper"].find(a.get("hair_color"))))
	refresh()
func refresh_preview()->void:
	if is_instance_valid(hair_color_choice):hair_color_choice.disabled=hair_choice.selected==0
	if is_instance_valid(hall):hall.render_roster(slots,focus_slot,appearance() if editing or slots[focus_slot-1]==null else {})
func focus(slot:int)->void:
	if app.pending!="":return
	focus_slot=slot
	editing=false
	name_field.clear()
	feedback.text=""
	refresh()
func set_roster(data:Dictionary,kind:String)->void:
	if kind=="char_appearance":editing=false
	slots=data.get("slots",[null,null,null,null,null])
	selected_id=String(data.get("selected_id",""))
	if kind=="characters":
		for i in range(5):
			if slots[i] is Dictionary and slots[i].get("id")==selected_id:focus_slot=i+1
	refresh()
	match kind:
		"char_create":feedback.text="Personagem criado! Selecione para continuar."
		"char_appearance":feedback.text="Aparência atualizada."
		"char_select":feedback.text="Personagem escolhido. Visite Bravamar para conhecer a vila."
		"char_delete":feedback.text="Exclusão agendada; você pode cancelar."
		"char_cancel_delete":feedback.text="Exclusão cancelada."
		_:feedback.text=""
func refresh()->void:
	for i in range(5):
		var c:Variant=slots[i]
		var suffix:=""
		if c is Dictionary:
			if c.has("delete_at"):suffix=" • Pendente"
			elif c.get("id")==selected_id:suffix=" • Selecionado"
		slot_buttons[i].text="%02d  %s%s%s"%[i+1,"▸ " if focus_slot==i+1 else "",c.get("name")+"  ·  Nv. 1" if c is Dictionary else "Vazio",suffix]
	var active:Variant=slots[focus_slot-1]
	form.visible=active==null or editing
	name_field.visible=not editing
	cancel_edit.visible=editing
	create_button.text="Salvar aparência" if editing else "Criar personagem"
	details.visible=active is Dictionary and not editing
	if active is Dictionary:
		var pending:bool=active.has("delete_at")
		info.text="%s  •  Nível %d  •  %s\nKit inicial: picareta, machado, espada e 2 poções."%[active.get("name"),active.get("level"),active.get("city")]
		if pending:info.text+="\nExclusão: "+String(active.get("delete_at"))
		edit_button.visible=not pending
		choose.visible=not pending and active.get("id")!=selected_id
		enter_world.visible=not pending and active.get("id")==selected_id
		delete_button.visible=not pending
		cancel_delete.visible=pending
	refresh_preview()
func create_character()->void:
	if app.pending!="":return
	if editing:
		app.request("char_appearance","/v1/characters/"+String(slots[focus_slot-1].get("id"))+"/appearance",HTTPClient.METHOD_POST,JSON.stringify(appearance()))
	else:
		app.request("char_create","/v1/characters",HTTPClient.METHOD_POST,JSON.stringify({"slot":focus_slot,"name":name_field.text.strip_edges(),"appearance":appearance()}))
func change(action:String)->void:
	if app.pending!="" or not slots[focus_slot-1] is Dictionary:return
	app.request("char_"+action,"/v1/characters/"+String(slots[focus_slot-1].get("id"))+"/"+action,HTTPClient.METHOD_POST)
