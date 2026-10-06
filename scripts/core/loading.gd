extends Control

var status: Label
var progress: ProgressBar
var failed: bool = false


func _ready() -> void:
	theme = MenuShell.THEME
	var center := CenterContainer.new()
	add_child(center)
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var column := VBoxContainer.new()
	column.custom_minimum_size.x = 440
	center.add_child(column)
	status = MenuShell.label("LOADING_PRACTICE", 26)
	column.add_child(status)
	progress = ProgressBar.new()
	progress.show_percentage = false
	column.add_child(progress)
	column.add_child(MenuShell.button("MENU_BACK", func() -> void: SceneManager.navigate_to(SceneManager.Page.MAGES)))
	failed = ResourceLoader.load_threaded_request(SceneManager.SCENES[SceneManager.Page.PRACTICE]) != OK


func _process(_delta: float) -> void:
	if failed:
		status.text = "BOOT_ERROR"
		return
	var values: Array = []
	var state := ResourceLoader.load_threaded_get_status(SceneManager.SCENES[SceneManager.Page.PRACTICE], values)
	if not values.is_empty():
		progress.value = float(values[0]) * 100.0
	if state == ResourceLoader.THREAD_LOAD_LOADED and not SceneManager.is_transitioning:
		var scene := ResourceLoader.load_threaded_get(SceneManager.SCENES[SceneManager.Page.PRACTICE]) as PackedScene
		if scene == null or SceneManager.navigate_to(SceneManager.Page.PRACTICE) != OK:
			failed = true
	elif state in [ResourceLoader.THREAD_LOAD_FAILED, ResourceLoader.THREAD_LOAD_INVALID_RESOURCE]:
		failed = true
