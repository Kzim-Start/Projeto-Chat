extends MenuShell


func _ready() -> void:
	build_shell("MAP_TITLE", SceneManager.Page.MAIN_MENU)
	var hint := label("MAP_HINT", 20)
	hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(hint)
	# Containers own their children's transforms. Animate a child of a plain
	# Control so layout cannot replace the parchment's entrance transform.
	var holder := Control.new()
	holder.name = "ParchmentArea"
	holder.custom_minimum_size.y = 410
	holder.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content.add_child(holder)
	var parchment := ParchmentMap.new()
	parchment.name = "Parchment"
	holder.add_child(parchment)
	parchment.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	parchment.stage_selected.connect(_choose_stage)
	finish_shell()
	message.text = "MAP_PREVIEW_NOTICE"


func _choose_stage(id: StringName) -> void:
	if SceneManager.select_stage(id) == OK:
		SceneManager.navigate_to(SceneManager.Page.MAGES)
	else:
		message.text = "STAGE_LOCKED"
