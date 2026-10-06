class_name MenuShell
extends Control

const THEME := preload("res://assets/ui/foundation_theme.tres")
var content: VBoxContainer
var heading: Label
var coins_label: Label
var message: Label
var back_button: Button
var back_page: int = 2


func build_shell(title_key: String, destination: int) -> void:
	back_page = destination
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	theme = THEME
	var sky := NightSky.new()
	add_child(sky)
	var veil := ColorRect.new()
	veil.color = Color(0.018, 0.027, 0.05, 0.80)
	veil.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(veil)
	veil.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var safe := SafeArea.new()
	add_child(safe)
	safe.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	content = VBoxContainer.new()
	content.add_theme_constant_override("separation", 20)
	safe.add_child(content)
	var top := HBoxContainer.new()
	content.add_child(top)
	back_button = button("MENU_BACK", func() -> void: SceneManager.navigate_to(back_page))
	top.add_child(back_button)
	heading = label(title_key, 30)
	heading.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(heading)
	coins_label = label("", 20)
	coins_label.add_theme_color_override("font_color", Color("d9bb7d"))
	top.add_child(coins_label)
	message = label("", 18)
	message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	ProgressionManager.profile_changed.connect(refresh_coins)
	LocalizationManager.locale_changed.connect(func(_locale: String) -> void: refresh_coins())
	refresh_coins()
	back_button.grab_focus()


func refresh_coins() -> void:
	coins_label.text = tr("SAVED_COINS_VALUE").format({"coins": ProgressionManager.get_saved_coins()})


func finish_shell() -> void:
	content.add_child(message)
	if ProgressionManager.load_error != OK:
		message.text = "PROFILE_ERROR"


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		SceneManager.navigate_to(back_page)


static func label(text_key: String, font_size: int = 22) -> Label:
	var item := Label.new()
	item.text = text_key
	item.add_theme_font_size_override("font_size", font_size)
	return item


static func button(text_key: String, action: Callable) -> Button:
	var item := Button.new()
	item.text = text_key
	item.custom_minimum_size.y = 56
	item.pressed.connect(action)
	return item
