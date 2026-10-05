extends Node
## Standalone native test scene; no add-on or network required.

var checks: int = 0
var failures: int = 0
var test_directory: String


func _ready() -> void:
	if not "--test-mode" in OS.get_cmdline_user_args():
		push_error("Run with -- --test-mode to isolate test preferences.")
		get_tree().quit(1)
		return
	get_tree().create_timer(20.0).timeout.connect(func() -> void:
		push_error("FAIL: test watchdog expired")
		get_tree().quit(1)
	)
	test_directory = "user://tests/case_%s" % Time.get_ticks_usec()
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(test_directory))
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
	_test_locale_policy()
	_test_settings_store()
	await _test_scene_navigation()
	await _test_language_ui()
	_cleanup_test_files()
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
	bad_mage = catalog.get_mage(&"ice").duplicate(true) as MageData
	bad_mage.move_speed = NAN
	check(not bad_mage.validate().is_empty(), "Non-finite mage attributes rejected")
	var bad_loot := LootTableData.new()
	bad_loot.id = &"invalid_probability"
	bad_loot.coin_drop_id = &"normal"
	bad_loot.mana_orb_chance = NAN
	check(not bad_loot.validate().is_empty(), "Non-finite loot probabilities rejected")
	var bad_reference := catalog.duplicate(true) as GameCatalog
	bad_reference.enemies[0].loot_table.coin_drop_id = &"missing_drop"
	check(not bad_reference.validate().is_empty(), "Broken cross-resource loot reference rejected")


func _test_translations() -> void:
	var english := load("res://assets/localization/en.po") as Translation
	var portuguese := load("res://assets/localization/pt_BR.po") as Translation
	check(english != null and portuguese != null, "Both translation resources import")
	if english == null or portuguese == null:
		return
	check(english.get_message_count() == portuguese.get_message_count(), "Locale key counts match")
	for key in english.get_message_list():
		check(not english.get_message(key).is_empty(), "English key is nonempty: " + key)
		check(not portuguese.get_message(key).is_empty(), "Portuguese key exists: " + key)
		check(_placeholders(english.get_message(key)) == _placeholders(portuguese.get_message(key)), "Locale placeholders match: " + key)
	for mage in GameManager.CATALOG.mages:
		check(not english.get_message(mage.name_key).is_empty(), "Mage name has translation: " + String(mage.id))
		check(not english.get_message(mage.description_key).is_empty(), "Mage description has translation: " + String(mage.id))
	var source_keys: Dictionary = {}
	for directory: String in ["res://scripts", "res://autoload", "res://scenes", "res://data"]:
		_collect_keys(directory, source_keys)
	for key: String in source_keys:
		check(not english.get_message(key).is_empty() and not portuguese.get_message(key).is_empty(), "Referenced UI key translated: " + key)


func _placeholders(message: String) -> PackedStringArray:
	var pattern := RegEx.create_from_string("\\{[a-z_]+\\}")
	var result := PackedStringArray()
	for found in pattern.search_all(message):
		result.append(found.get_string())
	result.sort()
	return result


func _collect_keys(directory: String, found: Dictionary) -> void:
	var pattern := RegEx.create_from_string('"([A-Z][A-Z0-9_]{2,})"')
	for file_name in DirAccess.get_files_at(directory):
		if file_name.get_extension() not in ["gd", "tscn", "tres"]:
			continue
		var content := FileAccess.get_file_as_string(directory.path_join(file_name))
		for match_result in pattern.search_all(content):
			found[match_result.get_string(1)] = true
	for child in DirAccess.get_directories_at(directory):
		_collect_keys(directory.path_join(child), found)


func _test_locale_policy() -> void:
	for portuguese: String in ["pt_BR", "pt-BR", "pt_PT", "pt", "PT_br"]:
		check(LocalePolicy.from_device_locale(portuguese) == "pt_BR", "Portuguese device locale: " + portuguese)
	for fallback: String in ["en_US", "en_GB", "es_MX", "fr_FR", "ja_JP", ""]:
		check(LocalePolicy.from_device_locale(fallback) == "en", "English fallback: " + fallback)
	check(not LocalePolicy.is_supported("es"), "Unsupported manual language rejected")
	check(ProjectSettings.get_setting("display/window/handheld/orientation") == 0, "Landscape configured")
	check(ProjectSettings.get_setting("rendering/renderer/rendering_method") == "gl_compatibility", "Compatibility renderer configured")


func _test_settings_store() -> void:
	var file_path := test_directory.path_join("settings.cfg")
	var store := SettingsStore.new(file_path)
	check(store.load_settings().error == ERR_FILE_NOT_FOUND, "First launch handles missing settings")
	check(store.save_locale("pt_BR") == OK, "Portuguese preference saves")
	check(SettingsStore.new(file_path).load_settings().locale == "pt_BR", "New store reloads Portuguese from disk")
	check(store.save_locale("en") == OK, "English preference saves")
	check(SettingsStore.new(file_path).load_settings().locale == "en", "New store reloads English from disk")
	check(FileAccess.file_exists(file_path + ".bak"), "Last valid settings backup exists")
	check(not FileAccess.file_exists(file_path + ".tmp"), "Successful save promotes temporary file")
	check(store.save_locale("invalid") == ERR_INVALID_PARAMETER, "Invalid locale is never written")
	check(store.load_settings().locale == "en", "Invalid locale preserves previous preference")
	_write_config(file_path, 1, 42)
	var recovered := store.load_settings()
	check(recovered.error == OK and recovered.locale == "pt_BR" and recovered.recovered, "Invalid primary recovers last valid backup")
	check(store.save_locale("en") == OK, "Can save after backup recovery")
	check(SettingsStore.new(file_path + ".bak").load_settings().locale == "pt_BR", "Corrupted primary never replaces good backup")
	_write_config(file_path, 99, "en")
	check(store.load_settings().error == ERR_UNAVAILABLE, "Newer schema is not silently downgraded")
	check(store.save_locale("pt_BR") == ERR_UNAVAILABLE, "Writing over newer schema is blocked")
	_write_config(file_path, 1, "not_supported")
	_write_config(file_path + ".bak", 1, "not_supported")
	check(store.load_settings().error == ERR_INVALID_DATA, "Two invalid settings files return a controlled error")
	_write_config(file_path, 1, "pt_BR")
	_write_config(file_path + ".tmp", 1, "en")
	check(store.load_settings().locale == "pt_BR", "Uncommitted temporary write is ignored")
	var blocker := FileAccess.open(test_directory.path_join("not_a_directory"), FileAccess.WRITE)
	blocker.store_string("test fixture")
	blocker.close()
	var blocked := SettingsStore.new(test_directory.path_join("not_a_directory/settings.cfg"))
	check(blocked.save_locale("en") != OK, "Storage write errors propagate")


func _write_config(file_path: String, version: int, locale: Variant) -> void:
	var config := ConfigFile.new()
	config.set_value("meta", "version", version)
	config.set_value("preferences", "locale", locale)
	check(config.save(file_path) == OK, "Settings fixture written")


func _test_scene_navigation() -> void:
	check(SceneManager.navigate_to(-1) == ERR_INVALID_PARAMETER, "Unknown destination rejected")
	# Remain alive while the actual current scene is replaced.
	get_tree().current_scene = null
	check(SceneManager.navigate_to(SceneManager.Page.FOUNDATION) == OK, "Scene navigation begins")
	check(SceneManager.navigate_to(SceneManager.Page.FOUNDATION) == ERR_BUSY, "Duplicate navigation blocked")
	await get_tree().scene_changed
	check(not SceneManager.is_transitioning, "Transition state clears")
	check(get_tree().current_scene.name == "Foundation", "Foundation scene is connected and ready")


func _test_language_ui() -> void:
	var foundation := get_tree().current_scene
	check(foundation.get_node("%MageList").get_child_count() == 3, "Three data-driven cards connected")
	foundation.get_node("%Settings").pressed.emit()
	await get_tree().scene_changed
	var settings := get_tree().current_scene
	check(settings.name == "SettingsScreen", "Settings button opens real scene")
	settings.get_node("%Portuguese").pressed.emit()
	await get_tree().process_frame
	check(LocalizationManager.current_locale == "pt_BR", "Portuguese button changes locale")
	check(settings.get_node("%CurrentLocale").text == "Idioma atual: Português do Brasil", "Dynamic UI updates immediately in Portuguese")
	check(SettingsStore.new(SettingsManager.store.path).load_settings().locale == "pt_BR", "UI choice persisted to disk")
	check(settings.get_node("%Portuguese").button_pressed and not settings.get_node("%English").button_pressed, "Exactly the chosen language is selected")
	settings.get_node("%English").pressed.emit()
	await get_tree().process_frame
	check(settings.get_node("%CurrentLocale").text == "Current language: English", "Dynamic UI updates immediately in English")
	check(LocalizationManager.set_language("unsupported") == ERR_INVALID_PARAMETER, "Manager rejects unsupported locale")
	check(LocalizationManager.current_locale == "en", "Invalid language leaves current UI unchanged")
	var original_store: SettingsStore = SettingsManager.store
	SettingsManager.store = SettingsStore.new(test_directory.path_join("not_a_directory/settings.cfg"))
	settings.get_node("%Portuguese").pressed.emit()
	check(LocalizationManager.current_locale == "en", "Failed write leaves active language unchanged")
	check(settings.get_node("%Message").text == "SETTINGS_SAVE_ERROR", "Failed write displays localized error key")
	SettingsManager.store = original_store
	settings.get_node("%Portuguese").pressed.emit()
	await get_tree().process_frame
	check(settings.get_node("%Message").text == "SETTINGS_SAVED", "Retry succeeds after storage is restored")
	settings.get_node("%Back").pressed.emit()
	await get_tree().scene_changed
	foundation = get_tree().current_scene
	check(foundation.name == "Foundation", "Back button returns to foundation")
	check(foundation.get_node("%MageList/ice/Content/MageName").text == "Mago de Gelo", "Reopened cards use saved language")
	check(LocalizationManager.set_language("en") == OK, "Live translation can change on foundation scene")
	await get_tree().process_frame
	check(foundation.get_node("%MageList/ice/Content/MageName").text == "Ice Mage", "Existing card updates without scene reload")
	check(foundation.get_node("%MageList/fire/Content/Status").text.contains("500"), "Price survives localization")
	await _check_layout(foundation)


func _check_layout(foundation: Node) -> void:
	for dimensions: Vector2i in [Vector2i(1280, 720), Vector2i(960, 540), Vector2i(1920, 1080), Vector2i(2340, 1080), Vector2i(1280, 800)]:
		get_window().size = dimensions
		await get_tree().process_frame
		await get_tree().process_frame
		var button: Button = foundation.get_node("%Settings")
		var viewport_rect: Rect2 = foundation.get_viewport_rect()
		check(viewport_rect.encloses(button.get_global_rect()), "Settings accessible at %s" % dimensions)
		var list: HBoxContainer = foundation.get_node("%MageList")
		check(list.get_child(0).size.x >= 280.0, "Readable card width at %s" % dimensions)


func _cleanup_test_files() -> void:
	# Only this test's uniquely named directory and its own immediate fixtures.
	for file_name in DirAccess.get_files_at(test_directory):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(test_directory.path_join(file_name)))
	DirAccess.remove_absolute(ProjectSettings.globalize_path(test_directory))
