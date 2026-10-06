class_name ProfileStore
extends RefCounted
## Menu progression only. No run coins, run snapshots or victory banking.

const VERSION: int = 1
const MAX_COINS: int = 2147483647
var path: String
var catalog: GameCatalog


func _init(file_path: String, definitions: GameCatalog) -> void:
	path = file_path
	catalog = definitions


static func initial_profile() -> Dictionary:
	return {"save_version": VERSION, "saved_coins": 0, "unlocked_mages": ["ice"], "unlocked_stages": ["desert"], "completed_stages": [], "permanent_upgrades": {}, "tutorial_completed": false, "settings": {}, "statistics": {}, "last_banked_run_id": ""}


func validate(data: Dictionary) -> bool:
	for key in initial_profile():
		if not data.has(key):
			return false
	if not _integer(data.save_version) or int(data.save_version) != VERSION:
		return false
	if not _integer(data.saved_coins) or data.saved_coins < 0 or data.saved_coins > MAX_COINS:
		return false
	for key: String in ["unlocked_mages", "unlocked_stages", "completed_stages"]:
		if not data[key] is Array:
			return false
		var seen: Dictionary = {}
		for id in data[key]:
			if not id is String or seen.has(id):
				return false
			seen[id] = true
			if key == "unlocked_mages" and catalog.get_mage(id) == null:
				return false
			if key != "unlocked_mages" and catalog.get_stage(id) == null:
				return false
	if not "ice" in data.unlocked_mages or not "desert" in data.unlocked_stages:
		return false
	for id in data.completed_stages:
		if not id in data.unlocked_stages:
			return false
	if not data.permanent_upgrades is Dictionary or not data.settings is Dictionary or not data.statistics is Dictionary:
		return false
	for id in data.permanent_upgrades:
		if id != "max_hp" or not _integer(data.permanent_upgrades[id]) or data.permanent_upgrades[id] < 0 or data.permanent_upgrades[id] > 3:
			return false
	return data.tutorial_completed is bool and data.last_banked_run_id is String


func load_profile() -> Dictionary:
	var primary := _read(path)
	if primary.error in [OK, ERR_UNAVAILABLE]:
		return primary
	var backup := _read(path + ".bak")
	if backup.error in [OK, ERR_UNAVAILABLE]:
		backup.recovered = backup.error == OK
		return backup
	return primary


func save_profile(data: Dictionary) -> Error:
	if not validate(data):
		return ERR_INVALID_DATA
	var previous := _read(path)
	if previous.error == ERR_UNAVAILABLE or _read(path + ".bak").error == ERR_UNAVAILABLE:
		return ERR_UNAVAILABLE
	var absolute_path := ProjectSettings.globalize_path(path)
	var error := DirAccess.make_dir_recursive_absolute(absolute_path.get_base_dir())
	if error != OK:
		return error
	var file := FileAccess.open(path + ".tmp", FileAccess.WRITE)
	if file == null:
		return FileAccess.get_open_error()
	file.store_string(JSON.stringify(data, "\t"))
	file.flush()
	error = file.get_error()
	file.close()
	if error != OK or _read(path + ".tmp").error != OK:
		return ERR_FILE_CORRUPT
	if previous.error == OK:
		error = DirAccess.copy_absolute(absolute_path, absolute_path + ".bak.tmp")
		if error != OK:
			return error
		error = DirAccess.rename_absolute(absolute_path + ".bak.tmp", absolute_path + ".bak")
		if error != OK:
			return error
	return DirAccess.rename_absolute(absolute_path + ".tmp", absolute_path)


func _read(file_path: String) -> Dictionary:
	var result := {"error": ERR_FILE_NOT_FOUND, "data": {}, "recovered": false}
	if not FileAccess.file_exists(file_path):
		return result
	var file := FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		result.error = FileAccess.get_open_error()
		return result
	var parser := JSON.new()
	var error := parser.parse(file.get_as_text())
	file.close()
	result.error = ERR_FILE_CORRUPT
	if error != OK or not parser.data is Dictionary:
		return result
	var data: Dictionary = parser.data
	if _integer(data.get("save_version")) and data.save_version > VERSION:
		result.error = ERR_UNAVAILABLE
	elif validate(data):
		result.error = OK
		result.data = data
	return result


static func _integer(value: Variant) -> bool:
	return (value is int or value is float) and is_finite(float(value)) and float(value) == floorf(float(value))
