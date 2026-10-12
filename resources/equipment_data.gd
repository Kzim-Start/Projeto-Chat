class_name EquipmentData
extends Resource
## Permanent equipment; prices use Saved Coins exclusively.

const SLOTS: Array[StringName] = [&"staff", &"mantle", &"amulet"]
@export var id: StringName
@export var name_key: StringName
@export var description_key: StringName
@export_enum("staff", "mantle", "amulet") var slot: String = "staff"
@export_range(0, 100000) var price: int = 0
@export_range(0.0, 10.0) var damage_flat: float = 0.0
@export_range(0.0, 1.0) var damage_percent: float = 0.0
@export_range(1, 2) var visual_tier: int = 1


func validate() -> PackedStringArray:
	var errors := PackedStringArray()
	if id.is_empty() or name_key.is_empty() or description_key.is_empty():
		errors.append("Equipment requires an ID and localization keys.")
	if not StringName(slot) in SLOTS:
		errors.append("Unknown equipment slot: " + slot)
	if price < 0 or not is_finite(damage_flat) or damage_flat < 0 or not is_finite(damage_percent) or damage_percent < 0 or damage_percent > 1:
		errors.append("Invalid equipment price or damage bonus: " + String(id))
	if visual_tier < 1 or visual_tier > 2:
		errors.append("Unsupported equipment visual tier: " + String(id))
	return errors
