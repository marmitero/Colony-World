extends Control
const ENDPOINT := "http://127.0.0.1:8090/v1/hello"
var http: HTTPRequest
var status_label: Label
var retry: Button

func _ready() -> void:
	var backdrop := ColorRect.new()
	backdrop.color = Color("#13251f")
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(backdrop)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(680, 360)
	var style := StyleBoxFlat.new()
	style.bg_color = Color("#1e322a")
	style.border_color = Color("#a88c5c")
	style.set_border_width_all(2)
	style.set_corner_radius_all(18)
	style.content_margin_left = 44
	style.content_margin_right = 44
	style.content_margin_top = 35
	style.content_margin_bottom = 35
	panel.add_theme_stylebox_override("panel", style)
	center.add_child(panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 20)
	panel.add_child(box)
	var eyebrow := Label.new()
	eyebrow.text = "COLONY WORLD    /    P0.1"
	eyebrow.add_theme_color_override("font_color", Color("#d1b179"))
	eyebrow.add_theme_font_size_override("font_size", 18)
	box.add_child(eyebrow)
	var title := Label.new()
	title.text = "Bravamar • Fundação técnica"
	title.add_theme_font_size_override("font_size", 32)
	box.add_child(title)
	var detail := Label.new()
	detail.text = "Primeira conexão local entre o cliente e o servidor.\nNão há autenticação ou gameplay nesta etapa."
	detail.add_theme_color_override("font_color", Color("#b5c7b9"))
	detail.add_theme_font_size_override("font_size", 18)
	box.add_child(detail)
	status_label = Label.new()
	status_label.text = "Verificando conexão..."
	status_label.add_theme_font_size_override("font_size", 20)
	box.add_child(status_label)
	retry = Button.new()
	retry.text = "Verificar conexão"
	retry.custom_minimum_size.y = 48
	retry.pressed.connect(check_connection)
	box.add_child(retry)
	http = HTTPRequest.new()
	http.timeout = 5
	add_child(http)
	http.request_completed.connect(on_response)
	check_connection()

func check_connection() -> void:
	retry.disabled = true
	status_label.text = "Conectando ao servidor local..."
	var err := http.request(ENDPOINT)
	if err != OK:
		status_label.text = "Não foi possível iniciar a conexão."
		retry.disabled = false

func on_response(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	retry.disabled = false
	var data: Variant = null
	if result == HTTPRequest.RESULT_SUCCESS and response_code == 200:
		data = JSON.parse_string(body.get_string_from_utf8())
	if result == HTTPRequest.RESULT_SUCCESS and response_code == 200 and data is Dictionary and data.get("service") == "colony-world" and data.get("protocol_version") == 1 and data.get("phase") == "P0.1":
		status_label.text = "Servidor conectado • protocolo v1"
		status_label.add_theme_color_override("font_color", Color("#a8d89b"))
		print("CW_P01_CONNECTED")
	else:
		status_label.text = "Servidor indisponível ou protocolo incompatível."
		status_label.add_theme_color_override("font_color", Color("#e9b49a"))
		print("CW_P01_OFFLINE")
