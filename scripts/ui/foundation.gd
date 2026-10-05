extends Control

@onready var mage_list: VBoxContainer = %MageList


func _ready() -> void:
	for mage in GameManager.CATALOG.mages:
		var row := Label.new()
		row.name = String(mage.id)
		row.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		mage_list.add_child(row)
	_refresh_text()


func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSLATION_CHANGED and is_node_ready():
		_refresh_text()


func _refresh_text() -> void:
	for mage in GameManager.CATALOG.mages:
		var status: String = tr("MAGE_STARTER") if mage.unlocked_by_default else tr("MAGE_LOCKED_PRICE").format({"price": GameManager.CATALOG.economy.get_mage_price(mage.id)})
		mage_list.get_node(String(mage.id)).text = tr("MAGE_SUMMARY").format({"mage": tr(mage.name_key), "status": status})
