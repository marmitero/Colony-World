extends Control
const BASE := "http://127.0.0.1:3000"
const Harbor = preload("res://harbor.gd")
const Characters = preload("res://character_screen.gd")
const WorldPreview = preload("res://world/world_screen.gd")
var world_preview:Control
var pending_world_character:Dictionary={}
var character_screen: Control
var login_margin: MarginContainer
var harbor: Node3D
var http: HTTPRequest
var sound: AudioStreamPlayer
var ambience: AudioStreamPlayer
var click_sound: AudioStreamPlayer
var email: LineEdit
var password: LineEdit
var confirm_password: LineEdit
var confirm_label: Label
var title: Label
var subtitle: Label
var feedback: Label
var status_label: Label
var submit: Button
var switch_mode: Button
var settings: Button
var auth_form: VBoxContainer
var signed_in: VBoxContainer
var account_label: Label
var settings_box: VBoxContainer
var volume: HSlider
var mode := "login"
var pending := ""
var session_token := ""
var online := false
var config := ConfigFile.new()
var camera_mode:=0
var camera_option:OptionButton
var reduced_motion := false

func _ready() -> void:
	harbor = Harbor.new()
	add_child(harbor)
	config.load("user://settings.cfg")
	camera_mode=clampi(int(config.get_value("gameplay","camera_mode",0)),0,2)
	reduced_motion = bool(config.get_value("menu","reduced_motion",false))
	harbor.drift_enabled = not reduced_motion
	sound = AudioStreamPlayer.new()
	var track: AudioStreamMP3 = preload("res://menu_assets/theme.mp3").duplicate()
	track.loop = true
	sound.stream = track
	add_child(sound)
	ambience = AudioStreamPlayer.new()
	var ambient: AudioStreamMP3 = preload("res://menu_assets/ambience.mp3").duplicate()
	ambient.loop = true
	ambience.stream = ambient
	add_child(ambience)
	click_sound = AudioStreamPlayer.new()
	click_sound.stream = preload("res://menu_assets/click.wav")
	add_child(click_sound)
	build_ui()
	set_volume(float(config.get_value("menu","volume",0.45)))
	sound.play()
	ambience.play()
	http = HTTPRequest.new()
	http.timeout = 10
	add_child(http)
	http.request_completed.connect(on_response)
	request("health","/healthz")

func label(text: String, size_: int, color: Color = Color("#e9e8db")) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size",size_)
	l.add_theme_color_override("font_color",color)
	return l
func button(text: String, primary: bool = false) -> Button:
	var b := Button.new()
	b.text = text
	b.pressed.connect(func(): click_sound.play())
	b.custom_minimum_size.y = 42
	b.add_theme_font_size_override("font_size",16)
	var s := StyleBoxFlat.new()
	s.bg_color = Color("#b19158") if primary else Color("#263b34")
	s.set_corner_radius_all(7)
	s.content_margin_top = 8
	s.content_margin_bottom = 8
	b.add_theme_stylebox_override("normal",s)
	var hover := s.duplicate() as StyleBoxFlat
	hover.bg_color = Color("#d0af70") if primary else Color("#3b5447")
	b.add_theme_stylebox_override("hover",hover)
	b.add_theme_color_override("font_color",Color("#121d18") if primary else Color("#e8e7d8"))
	return b
func field(placeholder: String, secret: bool = false) -> LineEdit:
	var e := LineEdit.new()
	e.placeholder_text = placeholder
	e.secret = secret
	e.max_length = 128 if secret else 254
	e.custom_minimum_size.y = 43
	e.add_theme_font_size_override("font_size",16)
	var s := StyleBoxFlat.new()
	s.bg_color = Color("#152520")
	s.border_color = Color("#41564b")
	s.set_border_width_all(1)
	s.set_corner_radius_all(5)
	s.content_margin_left = 12
	e.add_theme_stylebox_override("normal",s)
	return e
func build_ui() -> void:
	var veil := ColorRect.new()
	veil.color = Color(0.04,0.08,0.09,.34)
	veil.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	veil.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(veil)
	var margin := MarginContainer.new()
	login_margin=margin
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left",48)
	margin.add_theme_constant_override("margin_right",48)
	margin.add_theme_constant_override("margin_top",34)
	margin.add_theme_constant_override("margin_bottom",28)
	add_child(margin)
	var overall := VBoxContainer.new()
	margin.add_child(overall)
	var top := HBoxContainer.new()
	overall.add_child(top)
	top.add_child(label("COLONY   /   WORLD",22,Color("#e3c28a")))
	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(spacer)
	status_label = label("VERIFICANDO SERVIDOR...",14,Color("#e0c593"))
	top.add_child(status_label)
	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation",30)
	overall.add_child(body)
	var left := VBoxContainer.new()
	left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left.alignment = BoxContainer.ALIGNMENT_END
	body.add_child(left)
	left.add_child(label("NOVAS TERRAS, NOVOS CAMINHOS",14,Color("#e3c28a")))
	left.add_child(label("Bravamar",56))
	left.add_child(label("O primeiro porto de uma nova jornada.",18,Color("#e0ddcb")))
	var left_bottom := Control.new()
	left_bottom.custom_minimum_size.y = 50
	left.add_child(left_bottom)
	var center := CenterContainer.new()
	body.add_child(center)
	var panel := PanelContainer.new()
	panel.custom_minimum_size.x = 400
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.075,0.13,0.115,.96)
	style.border_color = Color("#aa905c")
	style.set_border_width_all(1)
	style.set_corner_radius_all(12)
	style.content_margin_left=28
	style.content_margin_right=28
	style.content_margin_top=24
	style.content_margin_bottom=24
	panel.add_theme_stylebox_override("panel",style)
	center.add_child(panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation",10)
	panel.add_child(box)
	title = label("Boas-vindas",28)
	box.add_child(title)
	subtitle = label("Entre na sua conta local de desenvolvimento.",14,Color("#b8c9ba"))
	box.add_child(subtitle)
	auth_form = VBoxContainer.new()
	auth_form.add_theme_constant_override("separation",8)
	box.add_child(auth_form)
	auth_form.add_child(label("E-mail",14))
	email=field("voce@exemplo.com")
	auth_form.add_child(email)
	auth_form.add_child(label("Senha",14))
	password=field("Mínimo de 12 caracteres",true)
	auth_form.add_child(password)
	confirm_label=label("Confirmar senha",14)
	auth_form.add_child(confirm_label)
	confirm_password=field("Repita sua senha",true)
	auth_form.add_child(confirm_password)
	submit=button("Entrar",true)
	submit.pressed.connect(submit_auth)
	auth_form.add_child(submit)
	switch_mode=button("Criar uma conta")
	switch_mode.pressed.connect(toggle_mode)
	auth_form.add_child(switch_mode)
	password.text_submitted.connect(func(_value): submit_auth())
	confirm_password.text_submitted.connect(func(_value): submit_auth())
	signed_in=VBoxContainer.new()
	signed_in.visible=false
	box.add_child(signed_in)
	account_label=label("",16,Color("#d8c9a2"))
	account_label.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
	signed_in.add_child(account_label)
	var open_chars:=button("Meus personagens",true)
	open_chars.pressed.connect(func():request("characters","/v1/characters"))
	signed_in.add_child(open_chars)
	var exit_button:=button("Sair da conta")
	exit_button.pressed.connect(logout)
	signed_in.add_child(exit_button)
	feedback=label("",14,Color("#e2c796"))
	feedback.custom_minimum_size.y=28
	feedback.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
	box.add_child(feedback)
	settings=button("Configurações")
	settings.pressed.connect(func(): settings_box.visible=not settings_box.visible)
	box.add_child(settings)
	settings_box=VBoxContainer.new()
	settings_box.visible=false
	box.add_child(settings_box)
	settings_box.add_child(label("Volume geral",14))
	volume=HSlider.new()
	volume.min_value=0
	volume.max_value=1
	volume.step=.05
	volume.value=float(config.get_value("menu","volume",.45))
	volume.value_changed.connect(set_volume)
	settings_box.add_child(volume)
	var motion:=CheckButton.new()
	motion.text="Reduzir movimento da câmera"
	motion.button_pressed=reduced_motion
	motion.toggled.connect(func(v): reduced_motion=v;harbor.drift_enabled=not v;config.set_value("menu","reduced_motion",v);config.save("user://settings.cfg"))
	settings_box.add_child(motion)
	settings_box.add_child(label("Visão do jogo",14))
	camera_option=OptionButton.new()
	for name_ in ["Visão superior","Terceira pessoa","Primeira pessoa"]:camera_option.add_item(name_)
	camera_option.select(camera_mode)
	camera_option.item_selected.connect(set_camera_preference)
	settings_box.add_child(camera_option)
	var refresh:=button("Verificar servidor")
	refresh.pressed.connect(func(): request("health","/healthz"))
	settings_box.add_child(refresh)
	overall.add_child(label("P0.7  •  Ambiente local de desenvolvimento  •  Contas de teste",13,Color("#e0ddcb")))
	update_mode()
func set_volume(v: float) -> void:
	sound.volume_db=linear_to_db(maxf(v,.0001))
	ambience.volume_db=linear_to_db(maxf(v*.28,.0001))
	click_sound.volume_db=linear_to_db(maxf(v*.2,.0001))
	config.set_value("menu","volume",v)
	config.save("user://settings.cfg")
func update_mode() -> void:
	var is_register:=mode=="register"
	title.text="Criar conta" if is_register else "Boas-vindas"
	subtitle.text="Crie uma conta local para seguir a jornada." if is_register else "Entre na sua conta local de desenvolvimento."
	confirm_label.visible=is_register
	confirm_password.visible=is_register
	submit.text="Criar conta" if is_register else "Entrar"
	switch_mode.text="Já tenho uma conta" if is_register else "Criar uma conta"
	password.clear()
	confirm_password.clear()
func toggle_mode() -> void:
	if pending!="":return
	mode="register" if mode=="login" else "login"
	feedback.text=""
	update_mode()
func submit_auth() -> void:
	if pending!="":return
	if not online:
		feedback.text="Servidor indisponível. Verifique a conexão."
		return
	if email.text.strip_edges()=="" or password.text.to_utf8_buffer().size()<12:
		feedback.text="Preencha o e-mail e uma senha com 12 caracteres ou mais."
		return
	if mode=="register" and password.text!=confirm_password.text:
		feedback.text="As senhas não coincidem."
		return
	var body:=JSON.stringify({"email":email.text.strip_edges(),"password":password.text})
	password.clear()
	confirm_password.clear()
	request(mode,"/v1/auth/"+mode,HTTPClient.METHOD_POST,body)
func request(kind: String,path: String,method: HTTPClient.Method=HTTPClient.METHOD_GET,body: String="") -> void:
	if pending!="":return
	pending=kind
	submit.disabled=true
	switch_mode.disabled=true
	var headers:=PackedStringArray(["Content-Type: application/json"])
	if session_token!="":headers.append("Authorization: Bearer "+session_token)
	var err:=http.request(BASE+path,headers,method,body)
	if err!=OK:
		pending=""
		submit.disabled=false
		switch_mode.disabled=false
		feedback.text="Não foi possível enviar a solicitação."
func on_response(result: int,code: int,_headers: PackedStringArray,body: PackedByteArray) -> void:
	var kind:=pending
	pending=""
	submit.disabled=false
	switch_mode.disabled=false
	var data: Variant=null
	if result==HTTPRequest.RESULT_SUCCESS and body.size()>0:
		data=JSON.parse_string(body.get_string_from_utf8())
	if kind=="health":
		online=result==HTTPRequest.RESULT_SUCCESS and code==200 and data is Dictionary and data.get("service")=="colony-world" and data.get("phase")=="P0.7" and data.get("protocol_version")==1
		status_label.text="● SERVIDOR LOCAL" if online else "● SERVIDOR OFFLINE"
		status_label.add_theme_color_override("font_color",Color("#a9d7a8") if online else Color("#e5a589"))
		print("CW_P07_CONNECTED" if online else "CW_P07_OFFLINE")
		return
	if kind=="logout":
		close_character_screen()
		session_token=""
		auth_form.visible=true
		signed_in.visible=false
		mode="login"
		feedback.text="Sessão encerrada."
		update_mode()
		return
	if kind=="register" and code==201:
		mode="login"
		update_mode()
		feedback.text="Conta criada. Entre com sua senha."
		return
	if kind=="login" and code==200 and data is Dictionary and data.has("token"):
		session_token=String(data["token"])
		request("me","/v1/auth/me")
		return
	if kind=="me" and code==200 and data is Dictionary and data.has("email"):
		auth_form.visible=false
		signed_in.visible=true
		title.text="Conta conectada"
		subtitle.text="Você está autenticado no servidor local."
		account_label.text=String(data["email"])
		feedback.text=""
		request("characters","/v1/characters")
		return
	if kind=="world_state":
		if code==200 and data is Dictionary and data.get("character_id")==pending_world_character.get("id"):
			character_screen.hide()
			world_preview=WorldPreview.new()
			add_child(world_preview)
			world_preview.setup(self,pending_world_character,data)
			return
		if is_instance_valid(character_screen):character_screen.feedback.text="Não foi possível entrar em Bravamar. Selecione novamente."
		return
	if kind=="characters" or kind.begins_with("char_"):
		if (code==200 or code==201) and data is Dictionary and data.has("slots"):
			if not is_instance_valid(character_screen):
				character_screen=Characters.new()
				add_child(character_screen)
				character_screen.setup(self)
				login_margin.hide()
				harbor.hide()
				harbor.drift_enabled=false
			character_screen.set_roster(data,kind)
			return
		if code==401:
			close_character_screen()
			session_token=""
			auth_form.show()
			signed_in.hide()
			mode="login"
			update_mode()
			feedback.text="Sessão expirada. Entre novamente."
			return
		if is_instance_valid(character_screen):
			var err_code:=String(data.get("error","")) if data is Dictionary else ""
			var messages:={"invalid_character":"Nome inválido: 3–20 caracteres, comece por uma letra.","name_taken":"Nome já utilizado.","slot_occupied":"Slot ocupado.","deletion_pending":"Exclusão pendente.","character_missing":"Personagem indisponível."}
			character_screen.feedback.text=messages.get(err_code,"Não foi possível concluir. Tente novamente.")
			return
	if kind=="me":session_token=""
	var error_code:=String(data.get("error","")) if data is Dictionary else ""
	match error_code:
		"invalid_credentials": feedback.text="E-mail ou senha inválidos."
		"account_unavailable": feedback.text="Não foi possível criar essa conta."
		"rate_limited": feedback.text="Muitas tentativas. Aguarde um minuto."
		"session_expired": feedback.text="Sessão inválida ou expirada."
		_: feedback.text="Não foi possível concluir. Tente novamente."
func logout() -> void:
	request("logout","/v1/auth/logout",HTTPClient.METHOD_POST)


func close_character_screen()->void:
	close_world_preview()
	if is_instance_valid(character_screen):
		character_screen.queue_free()
		character_screen=null
	login_margin.show()
	harbor.show()
	if is_instance_valid(harbor.camera):harbor.camera.make_current()
	harbor.drift_enabled=not reduced_motion

func open_world_preview(character:Dictionary)->void:
	if is_instance_valid(world_preview):return
	pending_world_character=character
	request("world_state","/v1/world/state")
func close_world_preview()->void:
	if is_instance_valid(world_preview):
		world_preview.village.enabled=false
		if is_instance_valid(world_preview.village.player):world_preview.village.player.set_physics_process(false)
		world_preview.queue_free()
		world_preview=null
	if is_instance_valid(character_screen):character_screen.show()

func set_camera_preference(mode:int)->void:
	camera_mode=clampi(mode,0,2)
	config.set_value("gameplay","camera_mode",camera_mode)
	config.save("user://settings.cfg")
	if is_instance_valid(camera_option):camera_option.select(camera_mode)
	if is_instance_valid(world_preview) and world_preview.village.camera_mode!=camera_mode:
		world_preview.village.set_camera_mode(camera_mode)
