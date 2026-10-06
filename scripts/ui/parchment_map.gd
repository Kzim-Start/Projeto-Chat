class_name ParchmentMap
extends Control

signal stage_selected(id: StringName)
var reveal: float = 0.0:
	set(value):
		reveal = value
		queue_redraw()
var _buttons: Array[Button] = []
var _entrance: Tween


func _ready() -> void:
	custom_minimum_size.y = 410
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	for stage in GameManager.CATALOG.stages:
		var item := Button.new()
		item.name = String(stage.id)
		item.custom_minimum_size = Vector2(190, 74)
		item.add_theme_font_size_override("font_size", 18)
		item.text = tr(stage.name_key) + "\n" + tr(_state_key(stage.id))
		item.disabled = true
		item.pressed.connect(func() -> void: stage_selected.emit(stage.id))
		add_child(item)
		_buttons.append(item)
	resized.connect(_position_nodes)
	_animate.call_deferred()


func _state_key(id: StringName) -> String:
	match ProgressionManager.get_stage_state(id):
		ProgressionManager.StageState.COMPLETED: return "STAGE_COMPLETED"
		ProgressionManager.StageState.UNLOCKED: return "STAGE_UNLOCKED"
		_: return "STAGE_LOCKED"


func _animate() -> void:
	_position_nodes()
	var destination := position
	position.x -= size.x + 100.0
	pivot_offset = size / 2.0
	rotation = -0.20
	scale = Vector2(0.72, 0.06)
	modulate.a = 0
	_entrance = create_tween()
	_entrance.set_parallel(true)
	_entrance.tween_property(self, "position", destination, 0.7).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	_entrance.tween_property(self, "modulate:a", 1.0, 0.25)
	_entrance.tween_property(self, "rotation", 0.0, 0.75).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	_entrance.tween_property(self, "scale", Vector2.ONE, 0.85).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	_entrance.tween_property(self, "reveal", 1.0, 0.9).set_trans(Tween.TRANS_CUBIC)
	await _entrance.finished
	for index in range(_buttons.size()):
		_buttons[index].disabled = ProgressionManager.get_stage_state(GameManager.CATALOG.stages[index].id) == ProgressionManager.StageState.LOCKED
	_buttons[0].grab_focus()


func _position_nodes() -> void:
	for index in range(_buttons.size()):
		var stage := GameManager.CATALOG.stages[index]
		_buttons[index].position = _map_point(stage.map_position) - _buttons[index].size / 2.0
	queue_redraw()


func _map_point(point: Vector2) -> Vector2:
	return Vector2(104, 55) + point * (size - Vector2(208, 110))


func _draw() -> void:
	draw_rect(Rect2(Vector2(4, 6), size - Vector2(8, 12)), Color("baa273"))
	draw_rect(Rect2(Vector2(16, 16), size - Vector2(32, 32)), Color("d5bd8b"))
	draw_rect(Rect2(Vector2(25, 25), size - Vector2(50, 50)), Color("a78c62"), false, 2)
	for y in range(35, int(size.y) - 30, 7):
		draw_line(Vector2(28, y), Vector2(size.x - 28, y), Color(0.39, 0.28, 0.17, 0.035))
	var rng := RandomNumberGenerator.new()
	rng.seed = 139
	for detail in range(115):
		var point := Vector2(rng.randf_range(42, size.x - 42), rng.randf_range(40, size.y - 40))
		var ink := Color(0.26, 0.29, 0.22, 0.25 * reveal)
		if point.x < size.x * 0.35:
			draw_polyline(PackedVector2Array([point + Vector2(-8, 4), point + Vector2(0, -7), point + Vector2(8, 4)]), ink, 2)
		else:
			draw_line(point, point + Vector2(0, 7), ink, 2)
			draw_polyline(PackedVector2Array([point + Vector2(-5, 2), point + Vector2(0, -7), point + Vector2(5, 2)]), ink, 2)
	var stages := GameManager.CATALOG.stages
	for index in range(1, stages.size()):
		draw_dashed_line(_map_point(stages[index - 1].map_position), _map_point(stages[index].map_position), Color(0.39, 0.25, 0.18, reveal * 0.8), 2, 8)
	for item in _buttons:
		item.modulate.a = reveal
