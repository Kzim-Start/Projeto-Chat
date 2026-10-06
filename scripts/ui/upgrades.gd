extends MenuShell

var level_label: Label
var buy_button: Button


func _ready() -> void:
	build_shell("MENU_UPGRADES", SceneManager.Page.MAIN_MENU)
	var panel := PanelContainer.new()
	content.add_child(panel)
	var column := VBoxContainer.new()
	panel.add_child(column)
	column.add_child(label("UPGRADE_HP_NAME", 30))
	column.add_child(label("UPGRADE_HP_DESC", 21))
	level_label = label("", 22)
	column.add_child(level_label)
	buy_button = button("", _purchase)
	column.add_child(buy_button)
	finish_shell()
	message.text = "UPGRADE_PREVIEW_NOTICE"
	_refresh()


func _refresh() -> void:
	level_label.text = tr("UPGRADE_LEVEL").format({"level": ProgressionManager.get_hp_level(), "max": 3})
	buy_button.text = tr("BUY_PRICE").format({"price": ProgressionManager.get_hp_price()})
	buy_button.disabled = ProgressionManager.get_hp_level() >= 3 or ProgressionManager.get_saved_coins() < ProgressionManager.get_hp_price() or ProgressionManager.load_error != OK
	if ProgressionManager.get_hp_level() >= 3:
		buy_button.text = "UPGRADE_MAX"


func _purchase() -> void:
	message.text = "PURCHASE_SUCCESS" if ProgressionManager.purchase_hp_upgrade() == OK else "PURCHASE_FAILED"
	_refresh()
