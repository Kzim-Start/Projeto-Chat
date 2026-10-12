extends Node
## Run with a real rendering driver; uses only isolated test preferences.


func _ready() -> void:
	if not OS.has_feature("debug") or DisplayServer.get_name() == "headless" or not "--test-mode" in OS.get_cmdline_user_args():
		push_error("Preview requires a graphical renderer and -- --test-mode.")
		get_tree().quit(1)
		return
	get_window().size = Vector2i(1280, 720)
	get_tree().create_timer(35).timeout.connect(func() -> void: get_tree().quit(1))
	_run.call_deferred()


func _run() -> void:
	LocalizationManager.set_language("pt_BR")
	get_tree().current_scene = null
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://docs/previews"))
	await _visit(SceneManager.Page.MAIN_MENU)
	await _capture("menu.png")
	await _visit(SceneManager.Page.WORLD_MAP)
	await get_tree().create_timer(1.1).timeout
	await _capture("mapa.png")
	await _visit(SceneManager.Page.MAGES)
	await _capture("magos.png")
	await _visit(SceneManager.Page.EQUIPMENT)
	await _capture("equipamentos.png")
	# A separate test-only profile illustrates an equipped mage. No real wallet
	# is modified and the screenshot explicitly labels the simulated balance.
	var original_store := ProgressionManager.store
	var original_profile := ProgressionManager._profile.duplicate(true)
	var original_error := ProgressionManager.load_error
	var fixture_path := "user://tests/preview_equipment.json"
	ProgressionManager.store = ProfileStore.new(fixture_path,GameManager.CATALOG)
	ProgressionManager._profile = ProfileStore.initial_profile()
	ProgressionManager._profile.saved_coins = 1500
	ProgressionManager.load_error = OK
	for id: StringName in [&"eclipse_staff",&"astral_mantle",&"moon_pendant"]:
		ProgressionManager.purchase_equipment(id)
		ProgressionManager.equip(&"ice",id)
	var arsenal := get_tree().current_scene
	arsenal._select_item(&"eclipse_staff")
	arsenal.message.text = "GEAR_PREVIEW_FIXTURE"
	await get_tree().process_frame
	await _capture("arsenal-equipado.png")
	ProgressionManager.store = original_store
	ProgressionManager._profile = original_profile
	ProgressionManager.load_error = original_error
	for suffix in ["",".bak",".tmp",".bak.tmp"]:
		DirAccess.remove_absolute(ProjectSettings.globalize_path(fixture_path+suffix))
	await _visit(SceneManager.Page.PRACTICE)
	var scene := get_tree().current_scene
	scene.player.cast_skill()
	await get_tree().create_timer(0.25).timeout
	await _capture("treino.png")
	print("PREVIEW PASS: six images captured from Godot rendering")
	get_tree().quit()


func _visit(page: int) -> void:
	if SceneManager.navigate_to(page) != OK:
		push_error("Preview navigation failed")
		get_tree().quit(1)
		return
	await get_tree().scene_changed
	await get_tree().process_frame
	await get_tree().process_frame


func _capture(filename: String) -> void:
	await RenderingServer.frame_post_draw
	var image := get_viewport().get_texture().get_image()
	var result := image.save_png("res://docs/previews/" + filename)
	if result != OK:
		push_error("Could not save preview image")
		get_tree().quit(1)
