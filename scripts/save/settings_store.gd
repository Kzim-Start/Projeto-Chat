class_name SettingsStore
extends RefCounted
## Preferences only. Not PermanentSave, RunSave or currency storage.
## Write -> validate -> keep last valid backup -> atomic rename.

const SCHEMA_VERSION: int = 1
var path: String


func _init(file_path: String = "user://settings.cfg") -> void:
	path = file_path


func load_settings() -> Dictionary:
	var primary := _read(path)
	if primary.error == OK or primary.error == ERR_UNAVAILABLE:
		return primary
	var backup := _read(path + ".bak")
	if backup.error == OK:
		backup.recovered = true
		return backup
	if backup.error == ERR_UNAVAILABLE:
		return backup
	return primary


func save_locale(locale: String) -> Error:
	if not LocalePolicy.is_supported(locale):
		return ERR_INVALID_PARAMETER
	var previous := _read(path)
	if previous.error == ERR_UNAVAILABLE or _read(path + ".bak").error == ERR_UNAVAILABLE:
		return ERR_UNAVAILABLE # Never downgrade a newer settings format.
	var absolute_path := ProjectSettings.globalize_path(path)
	var result := DirAccess.make_dir_recursive_absolute(absolute_path.get_base_dir())
	if result != OK:
		return result
	var config := ConfigFile.new()
	config.set_value("meta", "version", SCHEMA_VERSION)
	config.set_value("preferences", "locale", locale)
	result = config.save(path + ".tmp")
	if result != OK:
		return result
	if _read(path + ".tmp").error != OK:
		return ERR_FILE_CORRUPT
	if previous.error == OK:
		result = DirAccess.copy_absolute(absolute_path, absolute_path + ".bak.tmp")
		if result != OK:
			return result
		result = DirAccess.rename_absolute(absolute_path + ".bak.tmp", absolute_path + ".bak")
		if result != OK:
			return result
	return DirAccess.rename_absolute(absolute_path + ".tmp", absolute_path)


func _read(file_path: String) -> Dictionary:
	var result := {"error": OK, "locale": "", "recovered": false}
	if not FileAccess.file_exists(file_path):
		result.error = ERR_FILE_NOT_FOUND
		return result
	var config := ConfigFile.new()
	var error := config.load(file_path)
	if error != OK:
		result.error = error
		return result
	var version = config.get_value("meta", "version", null)
	var locale = config.get_value("preferences", "locale", null)
	if typeof(version) != TYPE_INT:
		result.error = ERR_INVALID_DATA
	elif version > SCHEMA_VERSION:
		result.error = ERR_UNAVAILABLE
	elif version != SCHEMA_VERSION or typeof(locale) != TYPE_STRING:
		result.error = ERR_INVALID_DATA
	elif not LocalePolicy.is_supported(locale):
		result.error = ERR_INVALID_DATA
	else:
		result.locale = locale
	return result
