extends Node

var preferred_locale: String = ""
var last_error: Error = OK
var recovered_backup: bool = false
var store: SettingsStore


func _ready() -> void:
	# Tests never touch the player's settings file.
	var settings_path := "user://settings.cfg"
	if OS.has_feature("debug") and "--test-mode" in OS.get_cmdline_user_args():
		settings_path = "user://tests/session_settings.cfg"
	store = SettingsStore.new(settings_path)
	var loaded := store.load_settings()
	preferred_locale = loaded.locale
	last_error = loaded.error
	recovered_backup = loaded.recovered


func save_locale(locale: String) -> Error:
	last_error = store.save_locale(locale)
	if last_error == OK:
		preferred_locale = locale
	return last_error
