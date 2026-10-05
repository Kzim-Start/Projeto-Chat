class_name LootTableData
extends Resource
## Describes rewards; actual spawning and Run Coins belong to later systems.

@export var id: StringName
@export var coin_drop_id: StringName
@export_range(0.0, 1.0) var mana_orb_chance: float = 0.1


func validate() -> PackedStringArray:
	var errors := PackedStringArray()
	if id.is_empty() or coin_drop_id.is_empty():
		errors.append("Loot table ID and economy drop ID are required.")
	if mana_orb_chance < 0.0 or mana_orb_chance > 1.0:
		errors.append("Loot probability must be between zero and one.")
	return errors
