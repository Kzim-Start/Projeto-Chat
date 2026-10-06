extends Control
## Input courtyard, not a campaign run. Targets never award money or progression.

const TUNING: ControlTuning = preload("res://data/controls.tres")
const BOLT_CAPACITY: int = 32
var player: PracticeMage
var controls: MobileControls
var targets: Array[Dictionary] = []
var bolts: Array[Dictionary] = []
var blizzards: Array[Dictionary] = []
var hud: Label
var mana_bar: ProgressBar
var feedback: Label
var _feedback_time: float = 0.0
var _time: float = 0.0
var _arena: Rect2


func _ready() -> void:
	theme = MenuShell.THEME
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	for index in range(BOLT_CAPACITY):
		bolts.append({"life": 0.0, "position": Vector2.ZERO, "direction": Vector2.ZERO})
	player = PracticeMage.new()
	player.name = "Player"
	add_child(player)
	player.bolt_requested.connect(_fire)
	player.spell_requested.connect(_blizzard)
	player.mana_empty.connect(func() -> void:
		feedback.text = "PRACTICE_NO_MANA"
		_feedback_time = 1.0
	)
	controls = MobileControls.new()
	controls.name = "MobileControls"
	add_child(controls)
	controls.movement_changed.connect(func(value: Vector2) -> void: player.movement = value)
	controls.attack_changed.connect(func(value: bool) -> void: player.attack_held = value)
	controls.skill_requested.connect(player.cast_skill)
	controls.dash_requested.connect(player.dash)
	_build_hud()
	resized.connect(_layout)
	_layout()


func _build_hud() -> void:
	var safe := SafeArea.new()
	safe.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(safe)
	safe.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var column := VBoxContainer.new()
	column.mouse_filter = Control.MOUSE_FILTER_IGNORE
	safe.add_child(column)
	var row := HBoxContainer.new()
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	column.add_child(row)
	var back := MenuShell.button("PRACTICE_EXIT", _leave)
	back.name = "Leave"
	row.add_child(back)
	var title := MenuShell.label("PRACTICE_TITLE", 26)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(title)
	hud = MenuShell.label("", 18)
	row.add_child(hud)
	mana_bar = ProgressBar.new()
	mana_bar.custom_minimum_size = Vector2(270, 20)
	mana_bar.size_flags_horizontal = Control.SIZE_SHRINK_END
	mana_bar.max_value = player.definition.max_mana
	mana_bar.show_percentage = false
	column.add_child(mana_bar)
	feedback = MenuShell.label("PRACTICE_HINT", 18)
	feedback.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	feedback.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(feedback)


func _layout() -> void:
	controls.release_all()
	_arena = Rect2(64, 186, maxf(300, size.x - 128), maxf(190, size.y - 350))
	player.bounds = _arena.grow(-24)
	player.position = _arena.get_center() + Vector2(-100, 30)
	targets.clear()
	for point: Vector2 in [Vector2(0.23, 0.45), Vector2(0.50, 0.23), Vector2(0.78, 0.46)]:
		targets.append({"position": _arena.position + point * _arena.size, "health": 3.0, "respawn": 0.0, "frozen": 0.0, "flash": 0.0})
	for bolt in bolts:
		bolt.life = 0.0
	blizzards.clear()
	queue_redraw()


func _physics_process(delta: float) -> void:
	_time += delta
	_feedback_time = maxf(0, _feedback_time - delta)
	if _feedback_time <= 0:
		feedback.text = "PRACTICE_HINT"
	var nearest := Vector2.ZERO
	var nearest_distance: float = INF
	for target in targets:
		target.flash = maxf(0, target.flash - delta)
		target.frozen = maxf(0, target.frozen - delta)
		if target.respawn > 0:
			target.respawn -= delta
			if target.respawn <= 0:
				target.health = 3.0
			continue
		var distance: float = player.position.distance_squared_to(target.position)
		if distance < nearest_distance:
			nearest_distance = distance
			nearest = target.position - player.position
	player.aiming = nearest if nearest_distance < INF else player.facing
	for bolt in bolts:
		if bolt.life <= 0:
			continue
		bolt.life -= delta
		bolt.position += bolt.direction * TUNING.projectile_speed * delta
		for target in targets:
			if target.respawn <= 0 and bolt.position.distance_to(target.position) < 30:
				_hit(target, player.definition.attack_damage)
				bolt.life = 0.0
				break
	for area in blizzards:
		area.life -= delta
		area.tick -= delta
		if area.tick <= 0:
			area.tick = 0.5
			for target in targets:
				if target.respawn <= 0 and target.position.distance_to(area.position) < 170:
					target.frozen = 2.0
					_hit(target, 0.5)
	blizzards = blizzards.filter(func(area: Dictionary) -> bool: return area.life > 0)
	controls.cooldowns.skill = player.skill_cooldown / player.definition.skill_cooldown
	controls.cooldowns.dash = player.dash_cooldown / player.definition.dash_cooldown
	controls.queue_redraw()
	mana_bar.value = player.mana
	hud.text = tr("PRACTICE_STATS").format({"hp": player.definition.max_hp + ProgressionManager.get_hp_level(), "shield": player.definition.max_shield, "mana": int(player.mana)})
	queue_redraw()


func _fire(origin: Vector2, direction: Vector2) -> void:
	for bolt in bolts:
		if bolt.life <= 0:
			bolt.position = origin
			bolt.direction = direction
			bolt.life = TUNING.projectile_lifetime
			return


func _blizzard(origin: Vector2) -> void:
	blizzards.append({"position": origin, "life": 2.5, "tick": 0.0})


func _hit(target: Dictionary, damage: float) -> void:
	target.health -= damage
	target.flash = 0.14
	if target.health <= 0:
		target.respawn = 1.8


func _leave() -> void:
	controls.release_all()
	SceneManager.navigate_to(SceneManager.Page.WORLD_MAP)


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		_leave()


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color("111622"))
	if player == null:
		return
	draw_rect(_arena.grow(18), Color("242836"))
	draw_rect(_arena, Color("34333a"))
	for y in range(int(_arena.position.y), int(_arena.end.y), 34):
		for x in range(int(_arena.position.x), int(_arena.end.x), 66):
			var tile := Rect2(x + (17 if y % 2 == 0 else 0), y, 63, 31).intersection(_arena)
			draw_rect(tile, Color("3d3a40").darkened(fposmod(x * 0.008 + y * 0.013, 0.13)))
	draw_rect(_arena, Color("79706a"), false, 3)
	draw_arc(_arena.get_center(), 85, 0, TAU, 48, Color(0.65, 0.49, 0.40, 0.22), 2)
	for corner: Vector2 in [_arena.position, Vector2(_arena.end.x, _arena.position.y), _arena.end, Vector2(_arena.position.x, _arena.end.y)]:
		draw_rect(Rect2(corner - Vector2(14, 22), Vector2(28, 44)), Color("5e5660"))
		draw_rect(Rect2(corner - Vector2(17, 25), Vector2(34, 7)), Color("948177"))
		draw_circle(corner + Vector2(0, -30), 25 + sin(_time * 4) * 3, Color(0.87, 0.43, 0.21, 0.06))
		draw_rect(Rect2(corner + Vector2(-3, -36), Vector2(6, 11)), Color("e3a369"))
	for target in targets:
		var point: Vector2 = target.position
		if target.respawn > 0:
			draw_rect(Rect2(point + Vector2(-16, 12), Vector2(32, 5)), Color("777181"))
			continue
		var color := Color("9a8270") if target.frozen <= 0 else Color("9bdfed")
		if target.flash > 0:
			color = Color.WHITE
		draw_circle(point + Vector2(0, 17), 22, Color(0, 0, 0, 0.24))
		draw_rect(Rect2(point - Vector2(17, 32), Vector2(34, 48)), color.darkened(0.25))
		draw_rect(Rect2(point - Vector2(10, 43), Vector2(20, 18)), color)
		draw_rect(Rect2(point - Vector2(28, 17), Vector2(56, 9)), color)
		draw_rect(Rect2(point + Vector2(-20, -53), Vector2(40, 4)), Color("1d1c28"))
		draw_rect(Rect2(point + Vector2(-20, -53), Vector2(40 * maxf(0, target.health) / 3.0, 4)), Color("a9cccd"))
	for bolt in bolts:
		if bolt.life > 0:
			draw_line(bolt.position - bolt.direction * 18, bolt.position, Color("6299b6"), 6)
			draw_rect(Rect2(bolt.position - Vector2(4, 4), Vector2(8, 8)), Color("c3f8f1"))
	for area in blizzards:
		var alpha: float = minf(1, area.life) * 0.45
		draw_circle(area.position, 170, Color(0.48, 0.80, 0.90, alpha * 0.18))
		draw_arc(area.position, 170, 0, TAU, 60, Color(0.67, 0.90, 1, alpha), 3)
		for index in range(18):
			var point: Vector2 = area.position + Vector2.from_angle(index * 0.7 + _time * 1.4) * (40 + index * 7)
			draw_rect(Rect2(point, Vector2(4, 4)), Color(0.8, 0.96, 1, alpha))
