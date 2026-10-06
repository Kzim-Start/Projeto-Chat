extends Control

var coins: Label


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	theme = MenuShell.THEME
	add_child(NightSky.new())
	var margin := SafeArea.new()
	margin.padding = 36
	add_child(margin)
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 6)
	margin.add_child(column)
	var eyebrow := MenuShell.label("MENU_EYEBROW", 16)
	eyebrow.add_theme_color_override("font_color", Color("bc8274"))
	column.add_child(eyebrow)
	var title := MenuShell.label("GAME_TITLE_STACKED", 56)
	title.add_theme_color_override("font_color", Color("e8c69a"))
	title.add_theme_color_override("font_shadow_color", Color("471f30"))
	title.add_theme_constant_override("shadow_offset_y", 4)
	column.add_child(title)
	column.add_child(MenuShell.label("MENU_TAGLINE", 20))
	var gap := Control.new()
	gap.custom_minimum_size.y = 0
	column.add_child(gap)
	var entries := [["MENU_PLAY", SceneManager.Page.WORLD_MAP, "Play"], ["MENU_MAGES", SceneManager.Page.MAGES, "Mages"], ["MENU_UPGRADES", SceneManager.Page.UPGRADES, "Upgrades"], ["MENU_SETTINGS", SceneManager.Page.SETTINGS, "Settings"], ["MENU_CREDITS", SceneManager.Page.CREDITS, "Credits"]]
	for entry in entries:
		var page := int(entry[1])
		var item := MenuShell.button(entry[0], func() -> void: SceneManager.navigate_to(page))
		item.name = entry[2]
		item.custom_minimum_size = Vector2(342, 48)
		item.add_theme_font_size_override("font_size", 18)
		item.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		column.add_child(item)
		if page == SceneManager.Page.WORLD_MAP:
			item.grab_focus()
	var space := Control.new()
	space.size_flags_vertical = Control.SIZE_EXPAND_FILL
	column.add_child(space)
	var footer := HBoxContainer.new()
	column.add_child(footer)
	coins = MenuShell.label("", 18)
	coins.add_theme_color_override("font_color", Color("d7b77c"))
	footer.add_child(coins)
	var version := MenuShell.label("", 16)
	version.text = tr("BUILD_VERSION").format({"version": ProjectSettings.get_setting("application/config/version")})
	version.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	version.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	footer.add_child(version)
	column.add_child(MenuShell.label("MENU_PREVIEW_NOTICE", 16))
	ProgressionManager.profile_changed.connect(_refresh)
	_refresh()


func _refresh() -> void:
	coins.text = tr("SAVED_COINS_VALUE").format({"coins": ProgressionManager.get_saved_coins()})
