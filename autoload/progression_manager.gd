extends Node

signal profile_changed
enum StageState { LOCKED, UNLOCKED, COMPLETED }
var store: ProfileStore
var _profile: Dictionary = ProfileStore.initial_profile()
var load_error: Error = OK


func _ready() -> void:
	var file_path := "user://permanent_save.json"
	if OS.has_feature("debug") and "--test-mode" in OS.get_cmdline_user_args():
		file_path = "user://tests/menu_profile.json"
	store = ProfileStore.new(file_path, GameManager.CATALOG)
	var loaded := store.load_profile()
	load_error = loaded.error
	if load_error == OK:
		_profile = loaded.data
	elif load_error == ERR_FILE_NOT_FOUND:
		load_error = store.save_profile(_profile)
	# Corrupt/future files remain intact and purchases are blocked until recovery.


func get_saved_coins() -> int:
	return int(_profile.saved_coins)


func is_mage_unlocked(id: StringName) -> bool:
	return String(id) in _profile.unlocked_mages


func get_stage_state(id: StringName) -> StageState:
	if String(id) in _profile.completed_stages:
		return StageState.COMPLETED
	if String(id) in _profile.unlocked_stages:
		return StageState.UNLOCKED
	return StageState.LOCKED


func purchase_mage(id: StringName) -> Error:
	if load_error != OK:
		return load_error
	var price := GameManager.CATALOG.economy.get_mage_price(id)
	if price < 0:
		return ERR_INVALID_PARAMETER
	if is_mage_unlocked(id):
		return ERR_ALREADY_EXISTS
	if get_saved_coins() < price:
		return ERR_UNAUTHORIZED
	var next := _profile.duplicate(true)
	next.saved_coins = get_saved_coins() - price
	next.unlocked_mages.append(String(id))
	return _commit(next)


func get_hp_level() -> int:
	return int(_profile.permanent_upgrades.get("max_hp", 0))


func get_hp_price() -> int:
	return int(ceil(GameManager.CATALOG.economy.permanent_upgrade_costs[&"max_hp_1"] * pow(1.5, get_hp_level())))


func purchase_hp_upgrade() -> Error:
	if load_error != OK:
		return load_error
	if get_hp_level() >= 3:
		return ERR_ALREADY_EXISTS
	var price := get_hp_price()
	if get_saved_coins() < price:
		return ERR_UNAUTHORIZED
	var next := _profile.duplicate(true)
	next.saved_coins = get_saved_coins() - price
	next.permanent_upgrades.max_hp = get_hp_level() + 1
	return _commit(next)


func _commit(next: Dictionary) -> Error:
	var error := store.save_profile(next)
	if error == OK:
		_profile = next
		profile_changed.emit()
	return error
