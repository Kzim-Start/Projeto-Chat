extends MenuShell

const SLOT_KEYS := {"staff":"SLOT_STAFF", "mantle":"SLOT_MANTLE", "amulet":"SLOT_AMULET"}

var catalog: GameCatalog
var mage_id: StringName = &"ice"
var selected_item: StringName = &"apprentice_charm"
var owned_only: bool = false
var portrait: MagePortrait
var mage_picker: OptionButton
var damage_label: Label
var item_buttons: Dictionary = {}
var slot_buttons: Dictionary = {}
var detail_title: Label
var detail_text: Label
var comparison: Label
var action_button: Button
var remove_button: Button
var inventory_button: Button
var shop_button: Button


func _ready() -> void:
	catalog = GameManager.CATALOG
	mage_id = SceneManager.selected_mage
	build_shell("GEAR_TITLE", SceneManager.equipment_return_page)
	content.add_theme_constant_override("separation", 12)
	var row := HBoxContainer.new()
	row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content.add_child(row)
	var hero_panel := PanelContainer.new()
	hero_panel.custom_minimum_size.x = 330
	row.add_child(hero_panel)
	var hero := VBoxContainer.new()
	hero.add_theme_constant_override("separation", 8)
	hero_panel.add_child(hero)
	mage_picker = OptionButton.new()
	mage_picker.name = "MagePicker"
	mage_picker.custom_minimum_size.y = 42
	mage_picker.add_theme_font_size_override("font_size",18)
	for mage in catalog.mages:
		mage_picker.add_item(tr(mage.name_key))
	mage_picker.item_selected.connect(_choose_mage)
	hero.add_child(mage_picker)
	portrait = MagePortrait.new()
	portrait.name = "EquippedMage"
	portrait.custom_minimum_size.y = 220
	portrait.size_flags_vertical = Control.SIZE_EXPAND_FILL
	hero.add_child(portrait)
	damage_label = label("",24)
	damage_label.add_theme_color_override("font_color",Color("e9cb91"))
	hero.add_child(damage_label)
	for slot in EquipmentData.SLOTS:
		var item := button("", _select_slot.bind(slot))
		item.name = String(slot)
		item.custom_minimum_size.y = 42
		item.add_theme_font_size_override("font_size",15)
		item.add_theme_stylebox_override("normal",_slot_style())
		item.add_theme_stylebox_override("hover",_slot_style(true))
		hero.add_child(item)
		slot_buttons[slot] = item
	var shop := VBoxContainer.new()
	shop.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	shop.add_theme_constant_override("separation",10)
	row.add_child(shop)
	var tabs := HBoxContainer.new()
	shop.add_child(tabs)
	shop_button = button("GEAR_SHOP",func() -> void: owned_only=false; _refresh())
	inventory_button = button("GEAR_INVENTORY",func() -> void: owned_only=true; _refresh())
	for tab in [shop_button,inventory_button]:
		tab.custom_minimum_size.y = 44
		tab.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		tab.add_theme_font_size_override("font_size",18)
		tab.toggle_mode = true
		tabs.add_child(tab)
	var scroll := ScrollContainer.new()
	scroll.name = "ItemsScroll"
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	shop.add_child(scroll)
	var grid := GridContainer.new()
	grid.columns = 2
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.add_theme_constant_override("h_separation",10)
	grid.add_theme_constant_override("v_separation",10)
	scroll.add_child(grid)
	for item: EquipmentData in catalog.equipment:
		var card := button("",_select_item.bind(item.id))
		card.name = String(item.id)
		card.custom_minimum_size = Vector2(220,90)
		card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		card.add_theme_font_size_override("font_size",16)
		card.icon = PixelArt.equipment_icon(item.slot,item.visual_tier)
		card.expand_icon = true
		card.add_theme_constant_override("icon_max_width",48)
		card.add_theme_constant_override("h_separation",10)
		card.add_theme_stylebox_override("normal",_slot_style())
		card.add_theme_stylebox_override("hover",_slot_style(true))
		var selected_style := _slot_style(true)
		selected_style.bg_color = Color("493335")
		card.add_theme_stylebox_override("pressed",selected_style)
		card.toggle_mode = true
		grid.add_child(card)
		item_buttons[item.id] = card
	var detail := PanelContainer.new()
	var detail_style := THEME.get_stylebox("panel","PanelContainer").duplicate() as StyleBoxFlat
	detail_style.content_margin_top = 12
	detail_style.content_margin_bottom = 12
	detail.add_theme_stylebox_override("panel",detail_style)
	shop.add_child(detail)
	var information := VBoxContainer.new()
	information.add_theme_constant_override("separation",5)
	detail.add_child(information)
	detail_title = label("",21)
	information.add_child(detail_title)
	detail_text = label("",16)
	detail_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	information.add_child(detail_text)
	comparison = label("",18)
	comparison.add_theme_color_override("font_color",Color("9fe3cf"))
	information.add_child(comparison)
	var actions := HBoxContainer.new()
	information.add_child(actions)
	action_button = button("",_activate)
	action_button.name = "BuyOrEquip"
	action_button.custom_minimum_size.y = 44
	action_button.add_theme_font_size_override("font_size",17)
	action_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	actions.add_child(action_button)
	remove_button = button("GEAR_UNEQUIP",_remove)
	remove_button.name = "RemoveItem"
	remove_button.custom_minimum_size.y = 44
	remove_button.add_theme_font_size_override("font_size",17)
	actions.add_child(remove_button)
	finish_shell()
	message.add_theme_font_size_override("font_size",16)
	message.text = "GEAR_HELP" if ProgressionManager.load_error == OK else "PROFILE_ERROR"
	ProgressionManager.profile_changed.connect(_refresh)
	LocalizationManager.locale_changed.connect(func(_locale: String) -> void: _refresh())
	_refresh()


func _slot_style(highlight: bool = false) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color("252734") if highlight else Color("181e2b")
	style.border_color = Color("ba9570") if highlight else Color("414153")
	style.set_border_width_all(1)
	style.content_margin_left = 10
	style.content_margin_right = 10
	style.content_margin_top = 6
	style.content_margin_bottom = 6
	return style


func _refresh() -> void:
	refresh_coins()
	var outfit := ProgressionManager.get_loadout(mage_id)
	portrait.element = catalog.get_mage(mage_id).element
	portrait.outfit = ProgressionManager.get_visual_loadout(mage_id)
	damage_label.text = tr("GEAR_DAMAGE").format({"damage":"%.2f" % ProgressionManager.get_attack_damage(mage_id)})
	for index in range(catalog.mages.size()):
		var mage := catalog.mages[index]
		mage_picker.set_item_text(index,tr(mage.name_key))
		mage_picker.set_item_disabled(index,not ProgressionManager.is_mage_unlocked(mage.id))
		if mage.id == mage_id:
			mage_picker.select(index)
	for slot in EquipmentData.SLOTS:
		var item := catalog.get_equipment(outfit.get(String(slot),""))
		slot_buttons[slot].text = tr(SLOT_KEYS[String(slot)])+" · "+(tr(item.name_key) if item != null else tr("GEAR_EMPTY"))
	shop_button.set_pressed_no_signal(not owned_only)
	inventory_button.set_pressed_no_signal(owned_only)
	for item: EquipmentData in catalog.equipment:
		var card: Button = item_buttons[item.id]
		var owned := ProgressionManager.owns_equipment(item.id)
		var equipped: bool = outfit.get(item.slot,"") == String(item.id)
		var status := tr("GEAR_EQUIPPED") if equipped else (tr("GEAR_OWNED") if owned else (tr("GEAR_FREE") if item.price == 0 else tr("GEAR_PRICE").format({"coins":item.price})))
		card.text = tr(item.name_key)+"\n"+_bonus(item)+"\n"+status
		card.tooltip_text = tr(item.description_key)
		card.visible = not owned_only or owned
		card.set_pressed_no_signal(item.id == selected_item)
	var selected := catalog.get_equipment(selected_item)
	if owned_only and not ProgressionManager.owns_equipment(selected_item):
		for item: EquipmentData in catalog.equipment:
			if ProgressionManager.owns_equipment(item.id):
				selected_item = item.id
				selected = item
				item_buttons[item.id].set_pressed_no_signal(true)
				break
	if owned_only and not ProgressionManager.owns_equipment(selected_item):
		detail_title.text = "GEAR_EMPTY_INVENTORY"
		detail_text.text = "GEAR_STARTER_HINT"
		comparison.text = ""
		action_button.hide()
		remove_button.hide()
		return
	detail_title.text = tr(selected.name_key)+"  /  "+tr(SLOT_KEYS[selected.slot])
	detail_text.text = tr(selected.description_key)
	comparison.text = tr("GEAR_COMPARISON").format({"before":"%.2f" % ProgressionManager.get_attack_damage(mage_id),"after":"%.2f" % ProgressionManager.get_attack_damage(mage_id,selected.id)})
	var owned := ProgressionManager.owns_equipment(selected.id)
	var equipped: bool = outfit.get(selected.slot,"") == String(selected.id)
	action_button.show()
	action_button.text = "GEAR_EQUIPPED" if equipped else ("GEAR_EQUIP" if owned else ("GEAR_CLAIM" if selected.price == 0 else tr("GEAR_BUY").format({"coins":selected.price})))
	action_button.disabled = equipped or ProgressionManager.load_error != OK or (not owned and ProgressionManager.get_saved_coins() < selected.price)
	remove_button.visible = equipped
	remove_button.disabled = ProgressionManager.load_error != OK


func _bonus(item: EquipmentData) -> String:
	var parts := PackedStringArray()
	if item.damage_flat > 0:
		parts.append(tr("GEAR_FLAT").format({"value":"%.2f" % item.damage_flat}))
	if item.damage_percent > 0:
		parts.append(tr("GEAR_PERCENT").format({"value":int(round(item.damage_percent*100))}))
	return " · ".join(parts)


func _choose_mage(index: int) -> void:
	var id := catalog.mages[index].id
	if SceneManager.select_mage(id) == OK:
		mage_id = id
		_refresh()


func _select_item(id: StringName) -> void:
	selected_item = id
	_refresh()


func _select_slot(slot: StringName) -> void:
	owned_only = false
	var id: String = ProgressionManager.get_loadout(mage_id).get(String(slot),"")
	if not id.is_empty():
		_select_item(StringName(id))
		return
	for item: EquipmentData in catalog.equipment:
		if item.slot == String(slot):
			_select_item(item.id)
			return


func _activate() -> void:
	var owned := ProgressionManager.owns_equipment(selected_item)
	var result := ProgressionManager.equip(mage_id,selected_item) if owned else ProgressionManager.purchase_equipment(selected_item)
	message.text = ("GEAR_EQUIP_SUCCESS" if owned else "GEAR_BOUGHT") if result == OK else "PURCHASE_FAILED"
	_refresh()


func _remove() -> void:
	var item := catalog.get_equipment(selected_item)
	var result := ProgressionManager.unequip(mage_id,StringName(item.slot))
	message.text = "GEAR_REMOVED" if result == OK else "PURCHASE_FAILED"
	_refresh()
