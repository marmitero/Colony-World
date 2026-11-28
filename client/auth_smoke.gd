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
	push_error("P05_SMOKE_FAIL "+message)
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
	var screen=app.character_screen
	if not is_instance_valid(screen) or screen.slots.size()!=5:
		fail("roster");return
	for slot in range(1,6):
		screen.focus(slot)
		screen.name_field.text="Viajante"+str(slot)
		screen.body_choice.select(slot%2)
		screen.outfit_choice.select(slot%3)
		screen.create_character()
		if not await wait_for_idle(app) or not screen.slots[slot-1] is Dictionary:
			fail("create slot "+str(slot));return
	screen.focus(3)
	screen.change("select")
	if not await wait_for_idle(app) or screen.selected_id!=screen.slots[2].get("id"):
		fail("select");return
	if not screen.enter_world.visible:
		fail("selected preview button");return
	screen.begin_edit()
	screen.hair_choice.select(2)
	screen.hair_color_choice.select(2)
	screen.skin_choice.select(1)
	screen.face_choice.select(1)
	screen.create_character()
	if not await wait_for_idle(app) or screen.slots[2]["appearance"].get("hair")!="swept":
		fail("appearance");return
	app.open_world_preview(screen.slots[2])
	if not await wait_for_idle(app):
		fail("world state");return
	await process_frame
	var world=app.world_preview
	if not is_instance_valid(world) or world.village.anchors.size()!=12 or world.village.layout["exits"].size()!=2:
		fail("world anchors and exits");return
	if world.village.instances!=world.village.layout["placements"].size() or world.village.collision_count!=126:
		fail("world instances");return
	world.village.set_focus(Vector3(0,0,-1),24)
	var wheel:=InputEventMouseButton.new()
	wheel.button_index=MOUSE_BUTTON_WHEEL_UP
	wheel.pressed=true
	Input.parse_input_event(wheel)
	await process_frame
	if world.village.zoom!=22.0:
		fail("camera wheel");return
	var angle:float=world.village.azimuth
	var rotate:=InputEventKey.new()
	rotate.keycode=KEY_Q
	rotate.pressed=true
	Input.parse_input_event(rotate)
	await process_frame
	if world.village.azimuth!=angle-15:
		fail("camera rotate");return
	var player=world.village.player
	if not is_instance_valid(player) or not player.walkable(Vector2(0,13.8)) or player.walkable(Vector2(0,50)):
		fail("collision geometry");return
	var initial:Vector2=player.authority
	player.test_direction=Vector2(0,-1)
	await create_timer(1.2).timeout
	if player.received<3 or player.authority.distance_to(initial)<1.0 or player.walk_clip!="Walk":
		fail("server movement");return
	var shift:=InputEventKey.new()
	shift.physical_keycode=KEY_SHIFT
	shift.pressed=true
	Input.parse_input_event(shift)
	await create_timer(.4).timeout
	if player.walk_clip!="Run":
		fail("run animation");return
	shift.pressed=false
	Input.parse_input_event(shift)
	player.test_direction=Vector2.ZERO
	await create_timer(.35).timeout
	if player.walk_clip!="Idle" or Vector2(player.position.x,player.position.z).distance_to(player.authority)>.1:
		fail("idle reconciliation");return
	world.village.toggle_markers()
	app.close_world_preview()
	await process_frame
	if not screen.visible or app.world_preview!=null:
		fail("return to selection");return
	screen.focus(5)
	screen.change("delete")
	if not await wait_for_idle(app) or not screen.slots[4].has("delete_at"):
		fail("delete schedule");return
	screen.change("cancel_delete")
	if not await wait_for_idle(app) or screen.slots[4].has("delete_at"):
		fail("cancel");return
	app.logout()
	if not await wait_for_idle(app) or app.session_token!="" or not app.auth_form.visible:
		fail("logout");return
	print("CW_P05_UI_MOVEMENT_OK")
	app.sound.stop()
	app.ambience.stop()
	app.click_sound.stop()
	await create_timer(.2).timeout
	app.queue_free()
	await process_frame
	await process_frame
	quit(0)
