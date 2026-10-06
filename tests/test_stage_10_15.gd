extends Node

var checks: int = 0
var failures: int = 0
var test_directory: String


func _ready() -> void:
	if not "--test-mode" in OS.get_cmdline_user_args():
		get_tree().quit(1)
		return
	test_directory = "user://tests/menus_%s" % Time.get_ticks_usec()
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(test_directory))
	get_tree().create_timer(30).timeout.connect(func() -> void:
		push_error("FAIL: menu/control test watchdog expired")
		get_tree().quit(1)
	)
	_run.call_deferred()


func check(condition: bool, description: String) -> void:
	checks += 1
	if condition:
		print("PASS: " + description)
	else:
		failures += 1
		push_error("FAIL: " + description)


func _run() -> void:
	_test_progression()
	_test_safe_area()
	await _test_flow()
	await _test_multitouch()
	for file_name in DirAccess.get_files_at(test_directory):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(test_directory.path_join(file_name)))
	DirAccess.remove_absolute(ProjectSettings.globalize_path(test_directory))
	print("MENU RESULT: %d checks, %d failures" % [checks, failures])
	get_tree().quit(0 if failures == 0 else 1)


func _test_progression() -> void:
	var catalog: GameCatalog = GameManager.CATALOG
	check(catalog.stages.size() == 6, "Six region definitions")
	check(catalog.get_stage(&"desert").prerequisite.is_empty(), "Desert is first region")
	check(ProgressionManager.get_stage_state(&"desert") == ProgressionManager.StageState.UNLOCKED, "Only initial stage is open")
	check(ProgressionManager.get_stage_state(&"hell") == ProgressionManager.StageState.LOCKED, "Final region remains locked")
	check(SceneManager.select_stage(&"forest") == ERR_UNAUTHORIZED, "Locked stage cannot be selected through API")
	check(SceneManager.select_stage(&"missing") == ERR_INVALID_PARAMETER, "Unknown stage rejected")
	check(SceneManager.select_mage(&"fire") == ERR_UNAUTHORIZED, "Locked mage cannot be selected through API")
	var original_store: ProfileStore = ProgressionManager.store
	var original_data: Dictionary = ProgressionManager._profile.duplicate(true)
	var original_error: Error = ProgressionManager.load_error
	var store := ProfileStore.new(test_directory.path_join("profile.json"), catalog)
	var fixture := ProfileStore.initial_profile()
	check(store.validate(fixture), "Initial profile validates")
	fixture.saved_coins = 2000
	check(store.save_profile(fixture) == OK, "Funded fixture saved to test-only profile")
	ProgressionManager.store = store
	ProgressionManager._profile = store.load_profile().data
	ProgressionManager.load_error = OK
	check(ProgressionManager.purchase_mage(&"fire") == OK, "Fire purchase succeeds with 500")
	check(ProgressionManager.get_saved_coins() == 1500, "Fire purchase deducts exactly 500")
	check(ProgressionManager.purchase_mage(&"fire") == ERR_ALREADY_EXISTS, "Repeated unlock is not charged twice")
	check(ProgressionManager.get_saved_coins() == 1500, "Duplicate purchase leaves wallet unchanged")
	check(ProgressionManager.purchase_mage(&"lightning") == OK, "Lightning purchase succeeds at exact price")
	check(ProgressionManager.get_saved_coins() == 0, "Wallet never goes negative")
	check(store.load_profile().data.unlocked_mages.size() == 3, "Unlocks and debit persisted together")
	check(ProgressionManager.purchase_hp_upgrade() == ERR_UNAUTHORIZED, "Insufficient upgrade funds rejected")
	fixture = ProfileStore.initial_profile()
	fixture.saved_coins = 600
	store.save_profile(fixture)
	ProgressionManager._profile = fixture.duplicate(true)
	check(ProgressionManager.purchase_hp_upgrade() == OK, "Permanent HP upgrade can be bought")
	check(ProgressionManager.get_hp_level() == 1 and ProgressionManager.get_saved_coins() == 500, "Upgrade level and debit commit together")
	check(ProgressionManager.get_hp_price() == 150, "Upgrade price increases")
	var blocker := FileAccess.open(test_directory.path_join("blocked"), FileAccess.WRITE)
	blocker.store_string("fixture")
	blocker.close()
	ProgressionManager.store = ProfileStore.new(test_directory.path_join("blocked/profile.json"), catalog)
	check(ProgressionManager.purchase_mage(&"fire") != OK, "Failed write rejects purchase")
	check(not ProgressionManager.is_mage_unlocked(&"fire") and ProgressionManager.get_saved_coins() == 500, "Failed purchase changes neither wallet nor unlock")
	var invalid := fixture.duplicate(true)
	invalid.saved_coins = -1
	check(not store.validate(invalid), "Negative balance rejected")
	invalid = fixture.duplicate(true)
	invalid.saved_coins = 1.5
	check(not store.validate(invalid), "Fractional currency rejected")
	invalid = fixture.duplicate(true)
	invalid.unlocked_mages.append("missing")
	check(not store.validate(invalid), "Unknown mage ID rejected in save")
	invalid = fixture.duplicate(true)
	invalid.completed_stages = ["hell"]
	check(not store.validate(invalid), "Locked stage cannot be marked completed")
	var corrupted := FileAccess.open(store.path, FileAccess.WRITE)
	corrupted.store_string("{truncated")
	corrupted.close()
	check(store.load_profile().error == OK and store.load_profile().recovered, "Broken primary profile recovers backup")
	var future := fixture.duplicate(true)
	future.save_version = 999
	var future_file := FileAccess.open(store.path, FileAccess.WRITE)
	future_file.store_string(JSON.stringify(future))
	future_file.close()
	check(store.save_profile(fixture) == ERR_UNAVAILABLE, "Future profile schema cannot be overwritten")
	ProgressionManager.store = original_store
	ProgressionManager._profile = original_data
	ProgressionManager.load_error = original_error


func _test_safe_area() -> void:
	var window := Rect2(0, 0, 2400, 1080)
	var safe := Rect2(80, 0, 2250, 1050)
	var insets := SafeArea.calculate_insets(window, safe, Vector2(1600, 720))
	check(is_equal_approx(insets.x, 80.0 * 2 / 3) and is_equal_approx(insets.z, 70.0 * 2 / 3), "Safe area scales both landscape notches")
	check(is_equal_approx(insets.w, 20.0), "Bottom gesture inset preserved")
	check(SafeArea.calculate_insets(window, Rect2(), Vector2(1600, 720)) == Vector4.ZERO, "Unavailable safe area falls back without hiding controls")


func _test_flow() -> void:
	get_tree().current_scene = null
	check(SceneManager.navigate_to(SceneManager.Page.MAIN_MENU) == OK, "Main menu loads")
	await get_tree().scene_changed
	var main := get_tree().current_scene
	check(main.find_child("Play", true, false) != null, "Play button exists")
	check(main.find_child("Continue", true, false) == null, "Continue is absent without a run save")
	main.find_child("Settings", true, false).pressed.emit()
	await get_tree().scene_changed
	check(SceneManager.settings_return_page == SceneManager.Page.MAIN_MENU, "Settings remembers main menu return")
	get_tree().current_scene.get_node("%Portuguese").pressed.emit()
	get_tree().current_scene.get_node("%Back").pressed.emit()
	await get_tree().scene_changed
	check(get_tree().current_scene.name == "MainMenu", "Settings returns to new main menu")
	get_tree().current_scene.find_child("Upgrades", true, false).pressed.emit()
	await get_tree().scene_changed
	check(get_tree().current_scene.name == "Upgrades", "Upgrade screen opens")
	check(get_tree().current_scene.buy_button.disabled, "Unaffordable upgrade visibly disabled")
	get_tree().current_scene.back_button.pressed.emit()
	await get_tree().scene_changed
	get_tree().current_scene.find_child("Credits", true, false).pressed.emit()
	await get_tree().scene_changed
	check(get_tree().current_scene.name == "Credits", "Credits screen opens")
	get_tree().current_scene.back_button.pressed.emit()
	await get_tree().scene_changed
	get_tree().current_scene.find_child("Play", true, false).pressed.emit()
	await get_tree().scene_changed
	var map := get_tree().current_scene
	check(map.name == "WorldMap", "Play opens parchment map")
	var parchment: ParchmentMap = map.find_child("Parchment", true, false)
	check(parchment._buttons.size() == 6, "Map contains six stage controls")
	await get_tree().create_timer(1.0).timeout
	check(parchment.reveal >= 0.99 and is_zero_approx(parchment.rotation), "Parchment entrance finishes")
	check(not parchment.get_node("desert").disabled and parchment.get_node("forest").disabled, "Only unlocked map button is enabled")
	parchment.get_node("desert").pressed.emit()
	await get_tree().scene_changed
	var selection := get_tree().current_scene
	check(selection.name == "MageSelection", "Stage leads to mage selection")
	check(selection.cards.get_child_count() == 3, "Three mage portraits displayed")
	check(selection.cards.get_node("fire").find_child("Choose", true, false).disabled, "Locked mage cannot launch practice")
	selection.cards.get_node("ice").find_child("Choose", true, false).pressed.emit()
	await get_tree().scene_changed
	check(get_tree().current_scene.name == "Loading", "Selected mage reaches loading scene")
	await get_tree().scene_changed
	check(get_tree().current_scene.name == "Practice", "Threaded loader reaches input courtyard")


func _touch(index: int, position: Vector2, pressed: bool, canceled: bool = false) -> void:
	var event := InputEventScreenTouch.new()
	event.index = index
	event.position = position
	event.pressed = pressed
	event.canceled = canceled
	get_viewport().push_input(event, true)


func _drag(index: int, position: Vector2) -> void:
	var event := InputEventScreenDrag.new()
	event.index = index
	event.position = position
	get_viewport().push_input(event, true)


func _test_multitouch() -> void:
	var scene := get_tree().current_scene
	var controls: MobileControls = scene.controls
	var player: PracticeMage = scene.player
	await get_tree().process_frame
	var origin := player.position
	_touch(10, controls.joystick_center, true)
	check(controls.movement == Vector2.ZERO, "Stick deadzone prevents drift")
	_drag(10, controls.joystick_center + Vector2(200, 150))
	check(is_equal_approx(controls.movement.length(), 1.0), "Stick clamps diagonal input to unit length")
	_touch(11, controls.centers.attack, true)
	await get_tree().create_timer(0.65).timeout
	check(player.position.distance_to(origin) > 10 and player.shot_count > 0, "Move and attack work simultaneously")
	check(controls.joystick_finger == 10 and controls.attack_held, "Independent movement/attack finger ownership")
	_touch(77, Vector2.ZERO, false)
	check(controls.attack_held and controls.joystick_finger == 10, "Unrelated release cannot cancel controls")
	_touch(12, controls.centers.skill, true)
	check(player.skill_count == 1 and controls.movement.length() > 0, "Move and skill work simultaneously")
	_touch(13, controls.centers.dash, true)
	check(player.dash_count == 1 and controls.movement.length() > 0, "Move and dash work simultaneously")
	check(controls.attack_held, "Skill and dash do not steal attack finger")
	_touch(12, controls.centers.skill, false)
	_touch(12, controls.centers.skill, true)
	check(player.skill_count == 1, "Skill cooldown rejects repeated taps")
	_drag(11, Vector2(-300, -300))
	_touch(11, Vector2(-300, -300), false)
	check(not controls.attack_held and controls.movement.length() > 0, "Releasing attack outside target leaves movement active")
	_touch(10, controls.joystick_center, true, true)
	check(controls.movement == Vector2.ZERO and controls.joystick_finger == -1, "Canceled touch releases joystick")
	_touch(20, controls.joystick_center + Vector2(50, 0), true)
	_touch(21, controls.centers.attack, true)
	controls.notification(NOTIFICATION_APPLICATION_FOCUS_OUT)
	check(controls.movement == Vector2.ZERO and not controls.attack_held, "Focus loss clears held inputs")
	check(player.movement == Vector2.ZERO and not player.attack_held, "Actor receives cancellation on focus loss")
	_touch(30, controls.joystick_center + Vector2(50, 0), true)
	controls._layout()
	check(controls.joystick_finger == -1, "Resize cancels stale pointer ownership")
	check(scene.bolts.size() == scene.BOLT_CAPACITY, "Practice projectile pool remains bounded")
	check(ProgressionManager.get_saved_coins() == 0, "Practice never grants permanent currency")
	scene.find_child("Leave", true, false).pressed.emit()
	await get_tree().scene_changed
	check(get_tree().current_scene.name == "WorldMap", "Exit courtyard returns to map")
