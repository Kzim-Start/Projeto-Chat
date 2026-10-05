extends Node
## Each invocation is a fresh Godot process with real Autoload initialization.


func _ready() -> void:
	var arguments := OS.get_cmdline_user_args()
	if not "--test-mode" in arguments or SettingsManager.store.path != "user://tests/session_settings.cfg":
		_finish(false, "Test preference isolation is required")
		return
	if "--probe-reset" in arguments:
		for suffix: String in ["", ".bak", ".tmp", ".bak.tmp"]:
			var file_path: String = SettingsManager.store.path + suffix
			if FileAccess.file_exists(file_path):
				if DirAccess.remove_absolute(ProjectSettings.globalize_path(file_path)) != OK:
					_finish(false, "Could not reset owned test fixture")
					return
		_finish(true, "Reset isolated preference fixture")
		return
	if "--probe-device" in arguments:
		var expected := LocalePolicy.from_device_locale(OS.get_locale())
		_finish(LocalizationManager.current_locale == expected and SettingsManager.preferred_locale == expected, "First launch detects and saves device locale")
		return
	for locale: String in LocalePolicy.SUPPORTED:
		if "--probe-write=" + locale in arguments:
			_finish(LocalizationManager.set_language(locale) == OK, "Saved preference: " + locale)
			return
		if "--probe-read=" + locale in arguments:
			_finish(LocalizationManager.current_locale == locale and SettingsManager.preferred_locale == locale, "Preference survives fresh process: " + locale)
			return
	_finish(false, "A probe operation is required")


func _finish(success: bool, message: String) -> void:
	if success:
		print("PROBE PASS: " + message)
	else:
		push_error("FAIL: " + message)
	get_tree().quit(0 if success else 1)
