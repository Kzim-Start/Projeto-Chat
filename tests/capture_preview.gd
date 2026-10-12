extends Node
## Run with a real rendering driver; uses only isolated test preferences.


func _ready() -> void:
	if DisplayServer.get_name() == "headless" or not "--test-mode" in OS.get_cmdline_user_args():
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
	await _visit(SceneManager.Page.PRACTICE)
	var scene := get_tree().current_scene
	scene.player.cast_skill()
	await get_tree().create_timer(0.25).timeout
	await _capture("treino.png")
	print("PREVIEW PASS: four images captured from Godot rendering")
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
