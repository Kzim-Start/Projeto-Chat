extends MenuShell


func _ready() -> void:
	build_shell("MAP_TITLE", SceneManager.Page.MAIN_MENU)
	var hint := label("MAP_HINT", 20)
	hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(hint)
	var parchment := ParchmentMap.new()
	parchment.name = "Parchment"
	content.add_child(parchment)
	parchment.stage_selected.connect(_choose_stage)
	finish_shell()
	message.text = "MAP_PREVIEW_NOTICE"


func _choose_stage(id: StringName) -> void:
	if SceneManager.select_stage(id) == OK:
		SceneManager.navigate_to(SceneManager.Page.MAGES)
	else:
		message.text = "STAGE_LOCKED"
