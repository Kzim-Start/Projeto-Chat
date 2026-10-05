extends Node
## Owns validated definitions, not player combat or mutable run state.

const CATALOG: GameCatalog = preload("res://data/game_catalog.tres")
var validation_errors := PackedStringArray()


func _ready() -> void:
	validation_errors = CATALOG.validate()
	for message in validation_errors:
		push_error(message)


func is_catalog_ready() -> bool:
	return validation_errors.is_empty()
