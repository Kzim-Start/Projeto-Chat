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
		if loaded.get("migrated", false):
			load_error = store.save_profile(_profile)
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
	var economy := GameManager.CATALOG.economy
	return int(ceil(economy.permanent_upgrade_costs[&"max_hp_1"] * pow(economy.max_hp_upgrade_multiplier, get_hp_level())))


func get_hp_bonus() -> int:
	return get_hp_level() * GameManager.CATALOG.economy.max_hp_per_level


func purchase_hp_upgrade() -> Error:
	if load_error != OK:
		return load_error
	if get_hp_level() >= GameManager.CATALOG.economy.max_hp_upgrade_levels:
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


func owns_equipment(id: StringName) -> bool:
	return String(id) in _profile.owned_equipment


func get_loadout(mage_id: StringName) -> Dictionary:
	return _profile.loadouts.get(String(mage_id), {}).duplicate(true)


func purchase_equipment(id: StringName) -> Error:
	if load_error != OK:
		return load_error
	var item := GameManager.CATALOG.get_equipment(id)
	if item == null:
		return ERR_INVALID_PARAMETER
	if owns_equipment(id):
		return ERR_ALREADY_EXISTS
	if get_saved_coins() < item.price:
		return ERR_UNAUTHORIZED
	var next := _profile.duplicate(true)
	next.saved_coins = get_saved_coins() - item.price
	next.owned_equipment.append(String(id))
	return _commit(next)


func equip(mage_id: StringName, id: StringName) -> Error:
	if load_error != OK:
		return load_error
	var item := GameManager.CATALOG.get_equipment(id)
	if item == null or GameManager.CATALOG.get_mage(mage_id) == null:
		return ERR_INVALID_PARAMETER
	if not is_mage_unlocked(mage_id) or not owns_equipment(id):
		return ERR_UNAUTHORIZED
	var outfit := get_loadout(mage_id)
	if outfit.get(item.slot, "") == String(id):
		return ERR_ALREADY_EXISTS
	outfit[item.slot] = String(id)
	var next := _profile.duplicate(true)
	next.loadouts[String(mage_id)] = outfit
	return _commit(next)


func unequip(mage_id: StringName, slot: StringName) -> Error:
	if load_error != OK:
		return load_error
	if not slot in EquipmentData.SLOTS or GameManager.CATALOG.get_mage(mage_id) == null:
		return ERR_INVALID_PARAMETER
	if not is_mage_unlocked(mage_id):
		return ERR_UNAUTHORIZED
	var outfit := get_loadout(mage_id)
	if not outfit.has(String(slot)):
		return ERR_DOES_NOT_EXIST
	outfit.erase(String(slot))
	var next := _profile.duplicate(true)
	next.loadouts[String(mage_id)] = outfit
	return _commit(next)


func get_attack_damage(mage_id: StringName, preview_item: StringName = &"") -> float:
	var mage := GameManager.CATALOG.get_mage(mage_id)
	if mage == null:
		return 0.0
	var outfit := get_loadout(mage_id)
	var preview := GameManager.CATALOG.get_equipment(preview_item)
	if preview != null:
		outfit[preview.slot] = String(preview.id)
	var flat: float = 0.0
	var percent: float = 0.0
	for id in outfit.values():
		var item := GameManager.CATALOG.get_equipment(id)
		if item != null:
			flat += item.damage_flat
			percent += item.damage_percent
	return (mage.attack_damage + flat) * (1.0 + percent)


func get_visual_loadout(mage_id: StringName) -> Vector3i:
	var result := Vector3i.ZERO
	var outfit := get_loadout(mage_id)
	for index in range(EquipmentData.SLOTS.size()):
		var item := GameManager.CATALOG.get_equipment(outfit.get(String(EquipmentData.SLOTS[index]), ""))
		if item != null:
			result[index] = item.visual_tier
	return result
