class_name PracticeMage
extends Node2D
## A controllable input-validation actor. Full combat/health systems come later.

signal bolt_requested(origin: Vector2, direction: Vector2)
signal spell_requested(origin: Vector2)
signal mana_empty

const TUNING: ControlTuning = preload("res://data/controls.tres")
var definition: MageData
var movement := Vector2.ZERO
var facing := Vector2.RIGHT
var aiming := Vector2.RIGHT
var attack_held: bool = false
var mana: float = 100.0
var attack_cooldown: float = 0.0
var skill_cooldown: float = 0.0
var dash_cooldown: float = 0.0
var dash_remaining: float = 0.0
var bounds := Rect2(70, 100, 1140, 440)
var shot_count: int = 0
var dash_count: int = 0
var skill_count: int = 0
var _time: float = 0.0
var _dash_direction := Vector2.RIGHT
var _trail: Array[Vector2] = []


func _ready() -> void:
	if definition == null:
		definition = GameManager.CATALOG.get_mage(SceneManager.selected_mage)
	mana = definition.max_mana


func _physics_process(delta: float) -> void:
	_time += delta
	attack_cooldown = maxf(0, attack_cooldown - delta)
	skill_cooldown = maxf(0, skill_cooldown - delta)
	dash_cooldown = maxf(0, dash_cooldown - delta)
	mana = minf(definition.max_mana, mana + TUNING.practice_mana_regeneration * delta)
	if movement.length_squared() > 0.001:
		facing = movement.normalized()
	var velocity := movement.limit_length(1.0) * definition.move_speed
	if dash_remaining > 0:
		dash_remaining -= delta
		velocity = _dash_direction * definition.move_speed * TUNING.dash_speed_multiplier
		_trail.append(position)
	if _trail.size() > 6 or (dash_remaining <= 0 and not _trail.is_empty()):
		_trail.pop_front()
	position += velocity * delta
	position = position.clamp(bounds.position, bounds.end)
	if attack_held and attack_cooldown <= 0:
		_attack()
	queue_redraw()


func _attack() -> void:
	attack_cooldown = 1.0 / definition.attack_speed
	if mana < definition.attack_cost:
		mana_empty.emit()
		return
	mana -= definition.attack_cost
	shot_count += 1
	bolt_requested.emit(position, aiming.normalized() if aiming.length_squared() > 0 else facing)


func cast_skill() -> void:
	if skill_cooldown > 0:
		return
	skill_cooldown = definition.skill_cooldown
	skill_count += 1
	spell_requested.emit(position)


func dash() -> void:
	if dash_cooldown > 0:
		return
	dash_cooldown = definition.dash_cooldown
	dash_remaining = TUNING.dash_duration
	_dash_direction = movement.normalized() if movement.length_squared() > 0 else facing
	dash_count += 1


func _draw() -> void:
	if definition == null:
		return
	for index in range(_trail.size()):
		draw_texture_rect(PixelArt.mage(definition.element), Rect2(_trail[index] - position - Vector2(40, 76), Vector2(80, 96)), false, Color(0.58, 0.86, 1, 0.08 + index * 0.03))
	draw_ellipse_shadow()
	var frame := int(_time * (8.0 if movement.length_squared() > 0 else 4.0)) % 4
	draw_texture_rect(PixelArt.mage(definition.element, frame), Rect2(-40, -76, 80, 96), false)
	draw_arc(Vector2(0, 8), 24, 0, TAU, 24, Color(0.46, 0.75, 0.86, 0.35), 2)


func draw_ellipse_shadow() -> void:
	draw_set_transform(Vector2(0, 12), 0, Vector2(1.8, 0.5))
	draw_circle(Vector2.ZERO, 17, Color(0, 0, 0, 0.4))
	draw_set_transform(Vector2.ZERO)
