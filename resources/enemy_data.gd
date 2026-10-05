class_name EnemyData
extends Resource

@export var id: StringName
@export var name_key: StringName
@export var max_hp: float = 3.0
@export var damage: float = 1.0
@export var speed: float = 70.0
@export var attack_range: float = 24.0
@export var attack_interval: float = 1.0
@export_enum("Melee", "Ranged", "Elite", "Boss") var enemy_type: int = 0
@export var loot_table: LootTableData
@export var biome: StringName
@export var difficulty_cost: int = 1


func validate() -> PackedStringArray:
	var errors := PackedStringArray()
	if id.is_empty() or name_key.is_empty() or biome.is_empty():
		errors.append("Enemy ID, name key and biome are required.")
	if max_hp <= 0.0 or damage <= 0.0 or speed < 0.0:
		errors.append("Enemy health, damage or movement is invalid: %s" % id)
	if attack_range <= 0.0 or attack_interval <= 0.0 or difficulty_cost <= 0:
		errors.append("Enemy attack or difficulty cost is invalid: %s" % id)
	if enemy_type not in [0, 1, 2, 3]:
		errors.append("Enemy type is invalid: %s" % id)
	if loot_table == null:
		errors.append("Enemy loot table is missing: %s" % id)
	else:
		errors.append_array(loot_table.validate())
	return errors
