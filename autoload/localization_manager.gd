extends Node

signal locale_changed(locale: String)
var current_locale: String = LocalePolicy.FALLBACK


func _ready() -> void:
	var initial_locale := SettingsManager.preferred_locale
	if initial_locale.is_empty():
		initial_locale = LocalePolicy.from_device_locale(OS.get_locale())
		SettingsManager.save_locale(initial_locale)
	_apply(initial_locale)


func set_language(locale: String) -> Error:
	if not LocalePolicy.is_supported(locale):
		return ERR_INVALID_PARAMETER
	if locale == current_locale and SettingsManager.preferred_locale == locale:
		return OK
	var result := SettingsManager.save_locale(locale)
	if result != OK:
		return result # Do not claim a persisted choice if the write failed.
	_apply(locale)
	return OK


func _apply(locale: String) -> void:
	current_locale = locale
	TranslationServer.set_locale(locale)
	locale_changed.emit(locale)
