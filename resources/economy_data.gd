class_name EconomyData
extends Resource
## Prices are Saved Coins; drops/rewards/shop prices are Run Coins.
## This is configuration, not a wallet or a banking implementation.

@export var fire_mage_price: int = 500
@export var lightning_mage_price: int = 1500
@export var max_hp_upgrade_levels: int = 3
@export var max_hp_upgrade_multiplier: float = 1.5
@export var max_hp_per_level: int = 1
@export var phase_rewards: Dictionary[StringName, int] = {}
@export var shop_prices: Dictionary[StringName, int] = {}
@export var permanent_upgrade_costs: Dictionary[StringName, int] = {}
@export var coin_drop_values: Dictionary[StringName, int] = {}


func get_mage_price(mage_id: StringName) -> int:
	match mage_id:
		&"ice": return 0
		&"fire": return fire_mage_price
		&"lightning": return lightning_mage_price
		_: return -1 # Unknown IDs must never become free unlocks.


func validate() -> PackedStringArray:
	var errors := PackedStringArray()
	if fire_mage_price <= 0 or lightning_mage_price <= fire_mage_price:
		errors.append("Mage prices must be positive; Lightning must cost more than Fire.")
	if max_hp_upgrade_levels <= 0 or max_hp_per_level <= 0 or not is_finite(max_hp_upgrade_multiplier) or max_hp_upgrade_multiplier < 1.0:
		errors.append("Permanent upgrade tuning is invalid.")
	for table: Dictionary in [phase_rewards, shop_prices, permanent_upgrade_costs, coin_drop_values]:
		if table.is_empty():
			errors.append("Economy tables must contain at least one configured entry.")
		for key: StringName in table:
			if key.is_empty() or table[key] <= 0:
				errors.append("Economy entries need an ID and a positive value.")
	return errors
