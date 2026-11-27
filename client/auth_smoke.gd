extends SceneTree
## Headless integration test only. Run with --script res://auth_smoke.gd.
func _initialize() -> void:
	call_deferred("run")

func wait_for_idle(app: Node) -> bool:
	for i in range(100):
		await create_timer(.1).timeout
		if app.pending=="":return true
	return false

func fail(message: String) -> void:
	push_error("P02_SMOKE_FAIL "+message)
	quit(1)

func run() -> void:
	var app = load("res://main.tscn").instantiate()
	root.add_child(app)
	if not await wait_for_idle(app) or not app.online:
		fail("health");return
	app.toggle_mode()
	app.email.text="ui-fixture@example.test"
	app.password.text="test-only-password-123"
	app.confirm_password.text="different-password"
	app.submit_auth()
	if app.feedback.text!="As senhas não coincidem.":
		fail("confirmation");return
	app.confirm_password.text="test-only-password-123"
	app.submit_auth()
	if not await wait_for_idle(app) or app.mode!="login":
		fail("register");return
	app.password.text="incorrect-password"
	app.submit_auth()
	if not await wait_for_idle(app) or app.feedback.text!="E-mail ou senha inválidos.":
		fail("bad login");return
	app.password.text="test-only-password-123"
	app.submit_auth()
	if not await wait_for_idle(app) or app.session_token=="" or not app.signed_in.visible:
		fail("login and me");return
	app.logout()
	if not await wait_for_idle(app) or app.session_token!="" or not app.auth_form.visible:
		fail("logout");return
	print("CW_P02_UI_AUTH_OK")
	app.sound.stop()
	app.ambience.stop()
	app.click_sound.stop()
	await create_timer(.2).timeout
	app.queue_free()
	await process_frame
	await process_frame
	quit(0)
