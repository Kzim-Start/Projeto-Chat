extends Control

const MAGE_CARD := preload("res://scenes/ui/mage_card.tscn")


func _ready() -> void:
	for mage in GameManager.CATALOG.mages:
		var card := MAGE_CARD.instantiate()
		card.name = String(mage.id)
		card.configure(mage, GameManager.CATALOG.economy)
		%MageList.add_child(card)
	%Settings.pressed.connect(_open_settings)
	%Settings.grab_focus()
	%Error.visible = SettingsManager.last_error != OK
	%Error.text = "SETTINGS_SAVE_ERROR"


func _open_settings() -> void:
	if SceneManager.navigate_to(SceneManager.Page.SETTINGS) != OK:
		%Error.text = "NAVIGATION_ERROR"
		%Error.show()
