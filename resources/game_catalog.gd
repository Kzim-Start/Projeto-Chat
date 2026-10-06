class_name GameCatalog
extends Resource

@export var mages: Array[MageData] = []
@export var enemies: Array[EnemyData] = []
@export var economy: EconomyData
@export var stages: Array[StageData] = []


func get_stage(stage_id: StringName) -> StageData:
	for stage in stages:
		if stage != null and stage.id == stage_id:
			return stage
	return null


func get_mage(mage_id: StringName) -> MageData:
	for mage in mages:
		if mage != null and mage.id == mage_id:
			return mage
	return null


func validate() -> PackedStringArray:
	var errors := PackedStringArray()
	var ids: Dictionary = {}
	if mages.size() != 3:
		errors.append("The initial catalog requires Ice, Fire and Lightning.")
	for mage in mages:
		if mage == null:
			errors.append("Catalog contains a missing mage.")
			continue
		errors.append_array(mage.validate())
		if ids.has(mage.id):
			errors.append("Duplicate mage ID: %s" % mage.id)
		ids[mage.id] = true
		if mage.unlocked_by_default != (mage.id == &"ice"):
			errors.append("Only Ice may be unlocked initially.")
	for required_id: StringName in [&"ice", &"fire", &"lightning"]:
		if not ids.has(required_id):
			errors.append("Missing mage: %s" % required_id)
	if economy == null:
		errors.append("Economy configuration is missing.")
	else:
		errors.append_array(economy.validate())
	ids.clear()
	for enemy in enemies:
		if enemy == null:
			errors.append("Catalog contains a missing enemy.")
			continue
		errors.append_array(enemy.validate())
		if ids.has(enemy.id):
			errors.append("Duplicate enemy ID: %s" % enemy.id)
		ids[enemy.id] = true
		if enemy.loot_table != null and economy != null:
			if not economy.coin_drop_values.has(enemy.loot_table.coin_drop_id):
				errors.append("Unknown coin drop in loot table: %s" % enemy.id)
	ids.clear()
	for stage in stages:
		if stage == null:
			errors.append("Catalog contains a missing stage.")
			continue
		errors.append_array(stage.validate())
		if ids.has(stage.id):
			errors.append("Duplicate stage ID: %s" % stage.id)
		if not stage.prerequisite.is_empty() and not ids.has(stage.prerequisite):
			errors.append("Stage prerequisite must precede it: %s" % stage.id)
		ids[stage.id] = true
	return errors
