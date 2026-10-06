extends Control


func _ready() -> void:
	%Portuguese.pressed.connect(_choose_language.bind("pt_BR"))
	%English.pressed.connect(_choose_language.bind("en"))
	%Back.pressed.connect(_go_back)
	LocalizationManager.locale_changed.connect(_on_locale_changed)
	_on_locale_changed(LocalizationManager.current_locale)
	%Message.text = "SETTINGS_RECOVERED" if SettingsManager.recovered_backup else "SETTINGS_AUTO_NOTICE"
	if SettingsManager.last_error != OK:
		%Message.text = "SETTINGS_SAVE_ERROR"
	%Back.grab_focus()


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		_go_back()


func _choose_language(locale: String) -> void:
	var result := LocalizationManager.set_language(locale)
	%Message.text = "SETTINGS_SAVED" if result == OK else "SETTINGS_SAVE_ERROR"
	_on_locale_changed(LocalizationManager.current_locale)


func _on_locale_changed(locale: String) -> void:
	%Portuguese.set_pressed_no_signal(locale == "pt_BR")
	%English.set_pressed_no_signal(locale == "en")
	%CurrentLocale.text = tr("SETTINGS_CURRENT_LANGUAGE").format({"language": tr("LANG_PT_BR" if locale == "pt_BR" else "LANG_EN")})


func _go_back() -> void:
	if SceneManager.navigate_to(SceneManager.settings_return_page) != OK:
		%Message.text = "NAVIGATION_ERROR"
