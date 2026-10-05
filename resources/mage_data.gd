class_name MageData
extends Resource
## Shared definition. Never store current HP, unlocks or run upgrades here.

@export var id: StringName
@export var name_key: StringName
@export var description_key: StringName
@export var max_hp: int = 8
@export var max_shield: int = 5
@export var max_mana: float = 100.0
@export var move_speed: float = 180.0
@export var attack_damage: float = 1.0
@export var attack_cost: float = 10.0
@export var attack_speed: float = 2.0 # Attacks per second.
@export var skill_cooldown: float = 8.0
@export var dash_cooldown: float = 1.2
@export_enum("Ice", "Fire", "Lightning") var element: int = 0
@export var sprite_data: SpriteFrames
@export var unlocked_by_default: bool = false


func validate() -> PackedStringArray:
	var errors := PackedStringArray()
	if id.is_empty() or name_key.is_empty() or description_key.is_empty():
		errors.append("Mage ID and localization keys are required.")
	if max_hp <= 0 or max_shield < 0 or max_mana <= 0.0:
		errors.append("Mage health, shield or mana is invalid: %s" % id)
	if move_speed <= 0.0 or attack_damage <= 0.0 or attack_speed <= 0.0:
		errors.append("Mage movement or attack is invalid: %s" % id)
	if attack_cost < 0.0 or attack_cost > max_mana:
		errors.append("Mage attack cost exceeds its mana capacity: %s" % id)
	if skill_cooldown <= 0.0 or dash_cooldown <= 0.0 or element not in [0, 1, 2]:
		errors.append("Mage cooldown or element is invalid: %s" % id)
	for value: float in [max_mana, move_speed, attack_damage, attack_cost, attack_speed, skill_cooldown, dash_cooldown]:
		if not is_finite(value):
			errors.append("Mage values must be finite: %s" % id)
	return errors
