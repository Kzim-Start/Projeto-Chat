extends PanelContainer

const ELEMENT_COLORS := [Color("86d9ec"), Color("f19975"), Color("b8a3ed")]
var mage: MageData
var economy: EconomyData


func configure(definition: MageData, prices: EconomyData) -> void:
	mage = definition
	economy = prices
	if is_node_ready():
		_refresh()


func _ready() -> void:
	_refresh()


func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSLATION_CHANGED and is_node_ready():
		_refresh()


func _refresh() -> void:
	if mage == null or economy == null:
		return
	%MageName.text = tr(mage.name_key)
	%MageName.add_theme_color_override("font_color", ELEMENT_COLORS[mage.element])
	%Accent.color = ELEMENT_COLORS[mage.element]
	%Description.text = tr(mage.description_key)
	%Status.text = tr("MAGE_STARTER") if mage.unlocked_by_default else tr("MAGE_LOCKED_PRICE").format({"price": economy.get_mage_price(mage.id)})
	%Stats.text = tr("MAGE_STATS").format({"hp": mage.max_hp, "shield": mage.max_shield, "mana": int(mage.max_mana)})
