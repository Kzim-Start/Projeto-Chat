extends MenuShell

var cards: HBoxContainer
var _portraits: Array[TextureRect] = []
var _time: float = 0.0


func _ready() -> void:
	build_shell("MAGE_SELECT_TITLE", SceneManager.mage_return_page)
	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content.add_child(scroll)
	cards = HBoxContainer.new()
	cards.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	cards.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.add_child(cards)
	_build_cards()
	finish_shell()
	message.text = "MAGE_PREVIEW_NOTICE"


func _build_cards() -> void:
	_portraits.clear()
	for child in cards.get_children():
		cards.remove_child(child)
		child.queue_free()
	for mage in GameManager.CATALOG.mages:
		var panel := PanelContainer.new()
		panel.name = String(mage.id)
		panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		cards.add_child(panel)
		var column := VBoxContainer.new()
		column.add_theme_constant_override("separation", 10)
		panel.add_child(column)
		var portrait := TextureRect.new()
		portrait.texture = PixelArt.mage(mage.element)
		portrait.custom_minimum_size.y = 105
		portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		column.add_child(portrait)
		_portraits.append(portrait)
		column.add_child(label(String(mage.name_key), 26))
		var info := label(tr("MAGE_FULL_STATS").format({"hp": mage.max_hp + ProgressionManager.get_hp_level(), "shield": mage.max_shield, "mana": int(mage.max_mana), "damage": mage.attack_damage}), 18)
		info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		column.add_child(info)
		for key: StringName in [mage.description_key, mage.attack_key, mage.skill_key, mage.passive_key]:
			var description := label(String(key), 17)
			description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			column.add_child(description)
		var gap := Control.new()
		gap.size_flags_vertical = Control.SIZE_EXPAND_FILL
		column.add_child(gap)
		var unlocked := ProgressionManager.is_mage_unlocked(mage.id)
		var status := label("MAGE_STARTER" if mage.unlocked_by_default else "MAGE_AVAILABLE", 17)
		if not unlocked:
			status.text = tr("MAGE_LOCKED_PRICE").format({"price": GameManager.CATALOG.economy.get_mage_price(mage.id)})
		column.add_child(status)
		var action := button("MAGE_ENTER_PRACTICE" if unlocked else "MAGE_BUY", _activate.bind(mage.id))
		action.name = "Choose"
		action.add_theme_font_size_override("font_size", 18)
		action.disabled = not unlocked and (ProgressionManager.get_saved_coins() < GameManager.CATALOG.economy.get_mage_price(mage.id) or ProgressionManager.load_error != OK)
		column.add_child(action)


func _process(delta: float) -> void:
	_time += delta
	for index in range(_portraits.size()):
		_portraits[index].texture = PixelArt.mage(index, int(_time * 5.0))


func _activate(id: StringName) -> void:
	if not ProgressionManager.is_mage_unlocked(id):
		var result := ProgressionManager.purchase_mage(id)
		message.text = "PURCHASE_SUCCESS" if result == OK else "PURCHASE_FAILED"
		_build_cards()
		return
	if SceneManager.select_mage(id) == OK:
		SceneManager.navigate_to(SceneManager.Page.LOADING)
