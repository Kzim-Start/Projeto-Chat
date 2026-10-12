extends Node

var checks: int = 0
var failures: int = 0
var directory: String
var original_store: ProfileStore
var original_profile: Dictionary
var original_error: Error


func _ready() -> void:
	if not OS.has_feature("debug") or not "--test-mode" in OS.get_cmdline_user_args():
		get_tree().quit(1)
		return
	directory = "user://tests/equipment_%s" % Time.get_ticks_usec()
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(directory))
	get_tree().create_timer(40).timeout.connect(func() -> void: get_tree().quit(1))
	_run.call_deferred()


func check(condition: bool, description: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		push_error("FAIL: " + description)
	else:
		print("PASS: " + description)


func _fixture(coins: int) -> void:
	var data := ProfileStore.initial_profile()
	data.saved_coins = coins
	data.unlocked_mages.append("fire")
	ProgressionManager.store.save_profile(data)
	ProgressionManager._profile = data
	ProgressionManager.load_error = OK


func _run() -> void:
	original_store = ProgressionManager.store
	original_profile = ProgressionManager._profile.duplicate(true)
	original_error = ProgressionManager.load_error
	ProgressionManager.store = ProfileStore.new(directory.path_join("inventory.json"),GameManager.CATALOG)
	_test_migration()
	_test_transactions()
	await _test_ui_and_damage()
	ProgressionManager.store = original_store
	ProgressionManager._profile = original_profile
	ProgressionManager.load_error = original_error
	for filename in DirAccess.get_files_at(directory):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(directory.path_join(filename)))
	DirAccess.remove_absolute(ProjectSettings.globalize_path(directory))
	print("EQUIPMENT RESULT: %d checks, %d failures" % [checks,failures])
	get_tree().quit(0 if failures == 0 else 1)


func _test_migration() -> void:
	var legacy := ProfileStore.initial_profile()
	legacy.save_version = 1
	legacy.erase("owned_equipment")
	legacy.erase("loadouts")
	legacy.saved_coins = 785
	legacy.unlocked_mages.append("fire")
	legacy.permanent_upgrades.max_hp = 2
	legacy.completed_stages.append("desert")
	legacy.unlocked_stages.append("forest")
	var file := FileAccess.open(directory.path_join("legacy.json"),FileAccess.WRITE)
	file.store_string(JSON.stringify(legacy))
	file.close()
	var store := ProfileStore.new(directory.path_join("legacy.json"),GameManager.CATALOG)
	var migrated := store.load_profile()
	check(migrated.error == OK and migrated.migrated and migrated.data.save_version == 2,"v1 profile migrates to equipment schema")
	check(migrated.data.saved_coins == 785 and migrated.data.unlocked_mages == legacy.unlocked_mages and migrated.data.permanent_upgrades.max_hp == 2,"Migration preserves wallet, mage unlocks and upgrades")
	check(migrated.data.completed_stages == legacy.completed_stages and migrated.data.unlocked_stages == legacy.unlocked_stages,"Migration preserves stage progress")
	check(migrated.data.owned_equipment.is_empty() and migrated.data.loadouts.is_empty(),"Migration does not award purchased gear")
	check(store.save_profile(migrated.data) == OK and not store.load_profile().migrated,"Migrated schema persists on disk")
	check(ProfileStore.new(store.path+".bak",GameManager.CATALOG).load_profile().data.saved_coins == 785,"Original v1 backup remains recoverable")
	var invalid: Dictionary = migrated.data.duplicate(true)
	invalid.erase("owned_equipment")
	check(not store.validate(invalid),"Malformed v2 is not silently treated as v1")
	var future := FileAccess.open(store.path,FileAccess.WRITE)
	invalid = migrated.data.duplicate(true)
	invalid.save_version = 99
	future.store_string(JSON.stringify(invalid))
	future.close()
	check(store.save_profile(migrated.data) == ERR_UNAVAILABLE,"Future equipment schema blocks downgrade")


func _test_transactions() -> void:
	_fixture(120)
	var manager := ProgressionManager
	check(GameManager.CATALOG.equipment.size() == 6,"Six configured equipment items")
	for item in GameManager.CATALOG.equipment:
		check(item.validate().is_empty(),"Equipment data validates: "+String(item.id))
	check(manager.purchase_equipment(&"missing") == ERR_INVALID_PARAMETER,"Unknown item rejected")
	check(manager.purchase_equipment(&"runic_staff") == OK and manager.get_saved_coins() == 0,"Exact-price purchase atomically debits wallet")
	check(manager.purchase_equipment(&"runic_staff") == ERR_ALREADY_EXISTS and manager.get_saved_coins() == 0,"Repeated purchase cannot charge twice")
	check(manager.purchase_equipment(&"eclipse_staff") == ERR_UNAUTHORIZED,"Insufficient funds cannot buy gear")
	check(manager.purchase_equipment(&"apprentice_charm") == OK and manager.get_saved_coins() == 0,"Starter gift costs no currency")
	check(manager.purchase_equipment(&"apprentice_charm") == ERR_ALREADY_EXISTS,"Starter gift can only be claimed once")
	check(manager.equip(&"lightning",&"runic_staff") == ERR_UNAUTHORIZED,"Locked mage cannot equip")
	check(manager.equip(&"ice",&"eclipse_staff") == ERR_UNAUTHORIZED,"Unowned item cannot equip")
	check(manager.equip(&"ice",&"runic_staff") == OK and manager.equip(&"ice",&"apprentice_charm") == OK,"Owned gear equips in separate slots")
	check(is_equal_approx(manager.get_attack_damage(&"ice"),1.35),"Flat bonuses increase actual attack damage")
	check(manager.equip(&"ice",&"runic_staff") == ERR_ALREADY_EXISTS and is_equal_approx(manager.get_attack_damage(&"ice"),1.35),"Repeated equip cannot stack the same bonus")
	check(manager.unequip(&"ice",&"staff") == OK and is_equal_approx(manager.get_attack_damage(&"ice"),1.1),"Unequip removes only the selected bonus")
	check(manager.owns_equipment(&"runic_staff"),"Unequip preserves ownership")
	manager.equip(&"ice",&"runic_staff")
	manager._profile.saved_coins = 1000 # Test-only funding; no production grant API.
	manager.store.save_profile(manager._profile)
	manager.purchase_equipment(&"embroidered_mantle")
	manager.purchase_equipment(&"moon_pendant")
	manager.equip(&"ice",&"embroidered_mantle")
	manager.equip(&"ice",&"moon_pendant")
	check(is_equal_approx(manager.get_attack_damage(&"ice"),1.7825),"Replacing amulet removes old bonus before applying percent modifier")
	check(is_equal_approx(manager.get_attack_damage(&"ice",&"apprentice_charm"),1.485),"Shop preview compares replacement, not stacked gear")
	check(manager.equip(&"fire",&"runic_staff") == OK and is_equal_approx(manager.get_attack_damage(&"fire"),1.75),"Owned equipment is reusable with independent mage loadouts")
	check(is_equal_approx(GameManager.CATALOG.get_mage(&"ice").attack_damage,1.0),"Equipment never mutates the shared MageData definition")
	var reloaded := ProfileStore.new(manager.store.path,GameManager.CATALOG).load_profile()
	check(reloaded.error == OK and reloaded.data.loadouts == manager._profile.loadouts and reloaded.data.saved_coins == 560,"New store restores loadouts, ownership and balance")
	var copy := manager.get_loadout(&"ice")
	copy.clear()
	check(manager.get_loadout(&"ice").size() == 3,"Public loadout reads cannot mutate profile")
	for malformed in ["duplicate","unknown","wrong_slot","not_owned"]:
		var bad := manager._profile.duplicate(true)
		match malformed:
			"duplicate": bad.owned_equipment.append("runic_staff")
			"unknown": bad.owned_equipment.append("missing")
			"wrong_slot": bad.loadouts.ice.staff = "moon_pendant"
			"not_owned": bad.loadouts.ice.staff = "eclipse_staff"
		check(not manager.store.validate(bad),"Invalid equipment state rejected: "+malformed)
	var good_store := manager.store
	var previous := manager._profile.duplicate(true)
	var blocker := FileAccess.open(directory.path_join("blocked"),FileAccess.WRITE)
	blocker.store_string("fixture")
	blocker.close()
	manager.store = ProfileStore.new(directory.path_join("blocked/save.json"),GameManager.CATALOG)
	check(manager.purchase_equipment(&"eclipse_staff") != OK and manager._profile == previous,"Write failure leaves both money and inventory unchanged")
	check(manager.equip(&"ice",&"apprentice_charm") != OK and manager._profile == previous,"Write failure cannot change loadout or damage")
	manager.store = good_store
	var damaged := FileAccess.open(good_store.path,FileAccess.WRITE)
	damaged.store_string("{broken")
	damaged.close()
	check(good_store.load_profile().error == OK and good_store.load_profile().recovered,"Equipment profile recovers valid backup")


func _test_ui_and_damage() -> void:
	_fixture(0)
	get_tree().current_scene = null
	SceneManager.selected_mage = &"ice"
	SceneManager.navigate_to(SceneManager.Page.MAIN_MENU)
	await get_tree().scene_changed
	get_tree().current_scene.find_child("Equipment",true,false).pressed.emit()
	await get_tree().scene_changed
	var screen := get_tree().current_scene
	await get_tree().process_frame
	await get_tree().process_frame
	check(screen.name == "Equipment" and screen.item_buttons.size() == 6,"Main menu opens real equipment shop")
	var visible_items: ScrollContainer = screen.find_child("ItemsScroll",true,false)
	for card in screen.item_buttons.values():
		check(visible_items.get_global_rect().encloses(card.get_global_rect()),"Shop card visible at reference resolution: "+card.name)
	check(screen.mage_picker.is_item_disabled(2),"Locked mage is disabled in wardrobe picker")
	check(not screen.action_button.disabled,"Free starter gift is available at zero balance")
	screen.action_button.pressed.emit()
	check(ProgressionManager.owns_equipment(&"apprentice_charm") and ProgressionManager.get_loadout(&"ice").is_empty(),"Buying an item adds inventory without silently equipping")
	screen.action_button.pressed.emit()
	check(is_equal_approx(ProgressionManager.get_attack_damage(&"ice"),1.1) and screen.portrait.outfit.z == 1,"Equip button changes saved damage and portrait layer")
	screen.item_buttons[&"runic_staff"].pressed.emit()
	check(screen.action_button.disabled,"Unaffordable purchase disabled in shop")
	screen.inventory_button.pressed.emit()
	check(not screen.item_buttons[&"runic_staff"].visible and screen.item_buttons[&"apprentice_charm"].visible,"Inventory shows only owned items")
	await get_tree().process_frame
	check(screen.get_global_rect().encloses(screen.action_button.get_global_rect()) and screen.get_global_rect().encloses(screen.portrait.get_global_rect()),"Wardrobe controls and character fit within viewport")
	screen.remove_button.pressed.emit()
	check(is_equal_approx(ProgressionManager.get_attack_damage(&"ice"),1.0),"Remove button restores base damage")
	screen.action_button.pressed.emit()
	LocalizationManager.set_language("en")
	await get_tree().process_frame
	check(TranslationServer.translate(screen.heading.text) == "Arcane arsenal" and "Damage" in screen.comparison.text,"Wardrobe updates locale without restart")
	LocalizationManager.set_language("pt_BR")
	screen.back_button.pressed.emit()
	await get_tree().scene_changed
	check(get_tree().current_scene.name == "MainMenu","Wardrobe returns to its entry screen")
	SceneManager.navigate_to(SceneManager.Page.MAGES)
	await get_tree().scene_changed
	get_tree().current_scene.cards.get_node("ice").find_child("Equipment",true,false).pressed.emit()
	await get_tree().scene_changed
	get_tree().current_scene.back_button.pressed.emit()
	await get_tree().scene_changed
	check(get_tree().current_scene.name == "MageSelection" and SceneManager.mage_return_page == SceneManager.Page.MAIN_MENU,"Mage selection equipment round-trip does not create a Back loop")
	SceneManager.navigate_to(SceneManager.Page.PRACTICE)
	await get_tree().scene_changed
	var practice := get_tree().current_scene
	check(is_equal_approx(practice.player.attack_damage,1.1),"Entering practice snapshots equipped damage")
	practice.player.set_physics_process(false)
	practice.player.position = practice.targets[0].position + Vector2(0,50)
	practice._fire(practice.player.position,Vector2.UP)
	await get_tree().create_timer(0.10).timeout
	check(is_equal_approx(practice.targets[0].health,1.9),"Projectile collision applies equipped damage to target")
	check(ProgressionManager.get_saved_coins() == 0,"Equipment testing does not award campaign currency")
	check(PixelArt.mage(0).get_width() == 96 and PixelArt.mage(0,0,Vector3i(1,1,1)) != PixelArt.mage(0),"Detailed character and equipment textures are distinct")
