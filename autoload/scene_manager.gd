extends Node

enum Page { FOUNDATION }
const SCENES: Dictionary[int, String] = {
	Page.FOUNDATION: "res://scenes/menus/foundation.tscn",
}
var is_transitioning: bool = false


func navigate_to(page: int) -> Error:
	if not SCENES.has(page):
		return ERR_INVALID_PARAMETER
	if is_transitioning:
		return ERR_BUSY
	var result := get_tree().change_scene_to_file(SCENES[page])
	if result == OK:
		is_transitioning = true
		get_tree().scene_changed.connect(_finish_transition, CONNECT_ONE_SHOT)
	return result


func _finish_transition() -> void:
	is_transitioning = false
