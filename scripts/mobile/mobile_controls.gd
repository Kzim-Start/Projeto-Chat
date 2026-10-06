class_name MobileControls
extends Control
## Each finger owns one control until release/cancel. Coordinates are viewport-local.

signal movement_changed(direction: Vector2)
signal attack_changed(held: bool)
signal skill_requested
signal dash_requested

const TUNING: ControlTuning = preload("res://data/controls.tres")
var movement := Vector2.ZERO
var attack_held: bool = false
var joystick_finger: int = -1
var action_fingers: Dictionary = {}
var joystick_center := Vector2.ZERO
var knob := Vector2.ZERO
var centers: Dictionary = {}
var cooldowns: Dictionary = {"skill": 0.0, "dash": 0.0}
var _touch_positions: Dictionary = {}
var _font: Font
var _labels: Dictionary = {"attack": "CONTROL_ATTACK", "skill": "CONTROL_SKILL", "dash": "CONTROL_DASH"}


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_font = ThemeDB.fallback_font
	resized.connect(_layout)
	get_window().focus_exited.connect(release_all)
	_layout()


func _layout() -> void:
	release_all()
	var insets := Vector4.ZERO
	if OS.get_name() in ["Android", "iOS"]:
		insets = SafeArea.calculate_insets(Rect2(Vector2(DisplayServer.window_get_position()), Vector2(DisplayServer.window_get_size())), Rect2(DisplayServer.get_display_safe_area()), size)
	joystick_center = Vector2(insets.x + 134, size.y - insets.w - 130)
	knob = joystick_center
	centers = {"attack": Vector2(size.x - insets.z - 108, size.y - insets.w - 124), "skill": Vector2(size.x - insets.z - 224, size.y - insets.w - 189), "dash": Vector2(size.x - insets.z - 238, size.y - insets.w - 75)}
	queue_redraw()


func _notification(what: int) -> void:
	if what in [NOTIFICATION_APPLICATION_PAUSED, NOTIFICATION_APPLICATION_FOCUS_OUT]:
		release_all()
	if what == NOTIFICATION_TRANSLATION_CHANGED:
		queue_redraw()


func _exit_tree() -> void:
	release_all()


func _input(event: InputEvent) -> void:
	if process_touch(event):
		get_viewport().set_input_as_handled()


func process_touch(event: InputEvent) -> bool:
	if event is InputEventScreenTouch:
		if not event.pressed or event.canceled:
			return _release(event.index)
		if event.index == joystick_finger or action_fingers.has(event.index):
			return true
		var point: Vector2 = event.position - global_position
		if joystick_finger == -1 and point.distance_to(joystick_center) <= TUNING.joystick_radius + 36:
			joystick_finger = event.index
			_drag_joystick(point)
			return true
		for action: String in centers:
			if point.distance_to(centers[action]) <= TUNING.action_radius + 10 and not action in action_fingers.values():
				action_fingers[event.index] = action
				_touch_positions[event.index] = point
				if action == "attack":
					attack_held = true
					attack_changed.emit(true)
				elif action == "skill":
					skill_requested.emit()
				else:
					dash_requested.emit()
				queue_redraw()
				return true
	elif event is InputEventScreenDrag:
		if event.index == joystick_finger:
			_drag_joystick(event.position - global_position)
			return true
		if action_fingers.has(event.index):
			_touch_positions[event.index] = event.position - global_position
			return true
	return false


func _drag_joystick(point: Vector2) -> void:
	var displacement := (point - joystick_center).limit_length(TUNING.joystick_radius)
	knob = joystick_center + displacement
	var strength := displacement.length() / TUNING.joystick_radius
	movement = Vector2.ZERO if strength < TUNING.joystick_deadzone else displacement.normalized() * (strength - TUNING.joystick_deadzone) / (1.0 - TUNING.joystick_deadzone)
	movement_changed.emit(movement)
	queue_redraw()


func _release(index: int) -> bool:
	if index == joystick_finger:
		joystick_finger = -1
		movement = Vector2.ZERO
		knob = joystick_center
		movement_changed.emit(movement)
		queue_redraw()
		return true
	if action_fingers.has(index):
		if action_fingers[index] == "attack":
			attack_held = false
			attack_changed.emit(false)
		action_fingers.erase(index)
		_touch_positions.erase(index)
		queue_redraw()
		return true
	return false


func release_all() -> void:
	joystick_finger = -1
	movement = Vector2.ZERO
	attack_held = false
	action_fingers.clear()
	_touch_positions.clear()
	knob = joystick_center
	movement_changed.emit(Vector2.ZERO)
	attack_changed.emit(false)
	queue_redraw()


func _draw() -> void:
	if _font == null:
		return
	var blue := Color("a8dce4")
	draw_circle(joystick_center, TUNING.joystick_radius, Color(0.06, 0.11, 0.16, 0.66))
	draw_arc(joystick_center, TUNING.joystick_radius, 0, TAU, 64, Color(0.58, 0.72, 0.77, 0.5), 2)
	draw_arc(joystick_center, TUNING.joystick_radius - 9, 0, TAU, 64, Color(0.58, 0.72, 0.77, 0.13), 1)
	draw_circle(knob, 29, Color(0.3, 0.53, 0.62, 0.85))
	draw_arc(knob, 29, 0, TAU, 32, blue, 2)
	for action: String in centers:
		var center: Vector2 = centers[action]
		var held := action in action_fingers.values()
		draw_circle(center, TUNING.action_radius, Color(0.24, 0.42, 0.5, 0.9) if held else Color(0.06, 0.10, 0.16, 0.83))
		draw_arc(center, TUNING.action_radius, 0, TAU, 48, blue if held else Color("6b8491"), 2)
		if float(cooldowns.get(action, 0)) > 0:
			draw_arc(center, TUNING.action_radius - 5, -PI / 2.0, -PI / 2.0 + TAU * cooldowns[action], 40, Color("d7b57c"), 4)
		var text_value := tr(_labels[action])
		var width := _font.get_string_size(text_value, HORIZONTAL_ALIGNMENT_LEFT, -1, 15).x
		draw_string(_font, center + Vector2(-width / 2.0, 5), text_value, HORIZONTAL_ALIGNMENT_LEFT, -1, 15, Color("e8e0c9"))
