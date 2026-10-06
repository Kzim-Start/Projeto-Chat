class_name NightSky
extends Control

var time: float = 0.0
var terrain: Texture2D
var _rng := RandomNumberGenerator.new()


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_rng.seed = 63015
	var image := Image.create(320, 180, false, Image.FORMAT_RGBA8)
	for y in range(180):
		var color := Color("080d19").lerp(Color("382533"), float(y) / 180.0)
		image.fill_rect(Rect2i(0, y, 320, 1), color)
	for star in range(115):
		image.set_pixel(_rng.randi_range(70, 315), _rng.randi_range(3, 102), Color("948392").darkened(_rng.randf() * 0.4))
	for y in range(8, 124):
		for x in range(172, 288):
			var distance := Vector2(x - 230, y - 65).length()
			if distance < 54.0:
				var shade := 0.16 + 0.11 * sin(x * 0.3) * sin(y * 0.26) + distance / 260.0
				image.set_pixel(x, y, Color("dc7464").darkened(shade))
	for layer in range(3):
		var tint := [Color("2b253a"), Color("1b2030"), Color("101522")][layer] as Color
		for x in range(320):
			var horizon := int(115 + layer * 16 + sin(float(x) * 0.043 + layer) * 15 + sin(float(x) * 0.16) * 5)
			image.fill_rect(Rect2i(x, horizon, 1, 180 - horizon), tint)
	for column in [180, 192, 289, 301]:
		image.fill_rect(Rect2i(column, 113, 6, 45), Color("111624"))
		image.fill_rect(Rect2i(column - 2, 111, 10, 4), Color("373043"))
	for y in range(150, 180, 6):
		image.fill_rect(Rect2i(157, y, 163, 1), Color("302939"))
	terrain = ImageTexture.create_from_image(image)


func _process(delta: float) -> void:
	time += delta
	queue_redraw()


func _draw() -> void:
	if terrain == null:
		return
	draw_texture_rect(terrain, Rect2(Vector2.ZERO, size), false)
	var scale_factor := size / Vector2(320, 180)
	for i in range(6):
		var x := fposmod(110.0 + i * 47.0 + time * (1.2 + i * 0.17), 370.0) - 30.0
		var y := 41.0 + i * 16.0
		draw_rect(Rect2(Vector2(x, y) * scale_factor, Vector2(73, 3) * scale_factor), Color(0.20, 0.15, 0.24, 0.4))
	var frame := int(time * 5.0) % 4
	var mage_position := Vector2(224, 113) * scale_factor
	draw_texture_rect(PixelArt.mage(0, frame), Rect2(mage_position, Vector2(38, 46) * scale_factor), false)
	var tip := mage_position + Vector2(28.5, 10.0) * scale_factor
	for ring in range(3, 0, -1):
		draw_circle(tip, (3.0 + ring * 3.0 + sin(time * 2.5)) * scale_factor.x, Color(0.40, 0.84, 0.91, 0.028 * (4 - ring)))
	for i in range(24):
		var spark := Vector2(178 + fposmod(i * 23 + sin(time + i) * 3, 120), 160 - fposmod(time * (2 + i % 3) + i * 13, 102))
		draw_rect(Rect2(spark.floor() * scale_factor, Vector2.ONE * scale_factor), Color(0.96, 0.52, 0.36, 0.28 + (i % 3) * 0.1))
	# Preserve legibility over the artwork without changing pixel coordinates.
	for x in range(0, 190):
		var alpha := 0.93 * (1.0 - smoothstep(65.0, 190.0, x))
		draw_rect(Rect2(x * scale_factor.x, 0, scale_factor.x + 1, size.y), Color(0.02, 0.035, 0.065, alpha))
