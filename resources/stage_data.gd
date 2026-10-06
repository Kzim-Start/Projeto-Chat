class_name StageData
extends Resource

@export var id: StringName
@export var name_key: StringName
@export var description_key: StringName
@export var prerequisite: StringName
@export var map_position: Vector2
@export var accent: Color = Color.WHITE


func validate() -> PackedStringArray:
	var errors := PackedStringArray()
	if id.is_empty() or name_key.is_empty() or description_key.is_empty():
		errors.append("Stage identity and translation keys are required.")
	if not map_position.is_finite() or map_position.x < 0.0 or map_position.x > 1.0 or map_position.y < 0.0 or map_position.y > 1.0:
		errors.append("Stage map position must be normalized: %s" % id)
	return errors
