extends Node

enum Page { FOUNDATION, SETTINGS, MAIN_MENU, WORLD_MAP, MAGES, UPGRADES, CREDITS, LOADING, PRACTICE }
const SCENES: Dictionary[int, String] = {
	Page.FOUNDATION: "res://scenes/menus/foundation.tscn",
	Page.SETTINGS: "res://scenes/menus/settings.tscn",
	Page.MAIN_MENU: "res://scenes/menus/main_menu.tscn",
	Page.WORLD_MAP: "res://scenes/map/world_map.tscn",
	Page.MAGES: "res://scenes/menus/mage_selection.tscn",
	Page.UPGRADES: "res://scenes/menus/upgrades.tscn",
	Page.CREDITS: "res://scenes/menus/credits.tscn",
	Page.LOADING: "res://scenes/boot/loading.tscn",
	Page.PRACTICE: "res://scenes/rooms/practice.tscn",
}
var is_transitioning: bool = false
var current_page: int = Page.FOUNDATION
var settings_return_page: int = Page.MAIN_MENU
var mage_return_page: int = Page.MAIN_MENU
var selected_stage: StringName = &"desert"
var selected_mage: StringName = &"ice"
var _pending_page: int = Page.FOUNDATION


func select_stage(id: StringName) -> Error:
	if GameManager.CATALOG.get_stage(id) == null:
		return ERR_INVALID_PARAMETER
	if ProgressionManager.get_stage_state(id) == ProgressionManager.StageState.LOCKED:
		return ERR_UNAUTHORIZED
	selected_stage = id
	return OK


func select_mage(id: StringName) -> Error:
	if GameManager.CATALOG.get_mage(id) == null:
		return ERR_INVALID_PARAMETER
	if not ProgressionManager.is_mage_unlocked(id):
		return ERR_UNAUTHORIZED
	selected_mage = id
	return OK


func navigate_to(page: int) -> Error:
	if not SCENES.has(page):
		return ERR_INVALID_PARAMETER
	if is_transitioning:
		return ERR_BUSY
	if page in [Page.LOADING, Page.PRACTICE]:
		if select_stage(selected_stage) != OK or select_mage(selected_mage) != OK:
			return ERR_UNAUTHORIZED
	if page == Page.SETTINGS:
		settings_return_page = current_page
	if page == Page.MAGES:
		mage_return_page = current_page
	var result := get_tree().change_scene_to_file(SCENES[page])
	if result == OK:
		_pending_page = page
		is_transitioning = true
		get_tree().scene_changed.connect(_finish_transition, CONNECT_ONE_SHOT)
	return result


func _finish_transition() -> void:
	current_page = _pending_page
	is_transitioning = false
