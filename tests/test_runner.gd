extends Node
## Standalone native test scene; no add-on or network required.

var checks: int = 0
var failures: int = 0


func _ready() -> void:
	_run.call_deferred()


func check(condition: bool, description: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		push_error("FAIL: " + description)
	else:
		print("PASS: " + description)


func _run() -> void:
	_test_catalog()
	_test_translations()
	await _test_scene_navigation()
	print("RESULT: %d checks, %d failures" % [checks, failures])
	get_tree().quit(0 if failures == 0 else 1)


func _test_catalog() -> void:
	var catalog: GameCatalog = GameManager.CATALOG
	check(GameManager.is_catalog_ready(), "Production catalog validates at boot")
	check(catalog.mages.size() == 3, "Three elemental mage definitions")
	check(catalog.get_mage(&"ice").unlocked_by_default, "Ice starts unlocked")
	check(not catalog.get_mage(&"fire").unlocked_by_default, "Fire starts locked")
	check(not catalog.get_mage(&"lightning").unlocked_by_default, "Lightning starts locked")
	check(catalog.economy.get_mage_price(&"fire") == 500, "Fire costs 500 Saved Coins")
	check(catalog.economy.get_mage_price(&"lightning") == 1500, "Lightning costs 1500 Saved Coins")
	check(catalog.economy.get_mage_price(&"missing") == -1, "Unknown mage is not a free unlock")
	check(catalog.get_mage(&"missing") == null, "Missing mage lookup is safe")
	var bad_mage := catalog.get_mage(&"ice").duplicate(true) as MageData
	bad_mage.attack_cost = bad_mage.max_mana + 1.0
	check(not bad_mage.validate().is_empty(), "Invalid attack cost rejected")
	check(catalog.get_mage(&"ice").attack_cost == 10.0, "Testing copies does not mutate shared definitions")
	var duplicate_catalog := catalog.duplicate(true) as GameCatalog
	duplicate_catalog.mages.append(duplicate_catalog.mages[0])
	check(not duplicate_catalog.validate().is_empty(), "Duplicate mage IDs rejected")
	var bad_enemy := catalog.enemies[0].duplicate(true) as EnemyData
	bad_enemy.loot_table = null
	check(not bad_enemy.validate().is_empty(), "Missing loot table rejected")
	var bad_economy := catalog.economy.duplicate(true) as EconomyData
	bad_economy.shop_prices[&"health_potion"] = -1
	check(not bad_economy.validate().is_empty(), "Negative economy values rejected")


func _test_translations() -> void:
	var english := load("res://assets/localization/en.po") as Translation
	var portuguese := load("res://assets/localization/pt_BR.po") as Translation
	check(english != null and portuguese != null, "Both translation resources import")
	if english == null or portuguese == null:
		return
	check(english.get_message_count() == portuguese.get_message_count(), "Locale key counts match")
	for key in english.get_message_list():
		check(not portuguese.get_message(key).is_empty(), "Portuguese key exists: " + key)
	for mage in GameManager.CATALOG.mages:
		check(not english.get_message(mage.name_key).is_empty(), "Mage name has translation: " + String(mage.id))
		check(not english.get_message(mage.description_key).is_empty(), "Mage description has translation: " + String(mage.id))


func _test_scene_navigation() -> void:
	check(SceneManager.navigate_to(-1) == ERR_INVALID_PARAMETER, "Unknown destination rejected")
	# Remain alive while the actual current scene is replaced.
	get_tree().current_scene = null
	check(SceneManager.navigate_to(SceneManager.Page.FOUNDATION) == OK, "Scene navigation begins")
	check(SceneManager.navigate_to(SceneManager.Page.FOUNDATION) == ERR_BUSY, "Duplicate navigation blocked")
	await get_tree().scene_changed
	check(not SceneManager.is_transitioning, "Transition state clears")
	check(get_tree().current_scene.name == "Foundation", "Foundation scene is connected and ready")
