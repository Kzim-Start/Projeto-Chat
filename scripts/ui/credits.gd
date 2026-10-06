extends MenuShell


func _ready() -> void:
	build_shell("MENU_CREDITS", SceneManager.Page.MAIN_MENU)
	for key: String in ["CREDITS_DESIGN", "CREDITS_ENGINE", "CREDITS_ART", "CREDITS_STATUS"]:
		var item := label(key, 24)
		item.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		content.add_child(item)
	finish_shell()
