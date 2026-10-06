class_name SafeArea
extends MarginContainer

@export var padding: int = 36


func _ready() -> void:
	get_viewport().size_changed.connect(refresh)
	refresh()


func refresh() -> void:
	var insets := Vector4.ZERO
	if OS.get_name() in ["Android", "iOS"]:
		var window := Rect2(Vector2(DisplayServer.window_get_position()), Vector2(DisplayServer.window_get_size()))
		insets = calculate_insets(window, Rect2(DisplayServer.get_display_safe_area()), get_viewport_rect().size)
	for index in range(4):
		add_theme_constant_override(["margin_left", "margin_top", "margin_right", "margin_bottom"][index], padding + int(insets[index]))


static func calculate_insets(window: Rect2, safe: Rect2, logical_size: Vector2) -> Vector4:
	if window.size.x <= 0.0 or window.size.y <= 0.0 or safe.size.x <= 0.0 or safe.size.y <= 0.0:
		return Vector4.ZERO
	var scale_factor := logical_size / window.size
	var overlap := window.intersection(safe)
	if not overlap.has_area():
		return Vector4.ZERO
	return Vector4(maxf(0, overlap.position.x - window.position.x) * scale_factor.x, maxf(0, overlap.position.y - window.position.y) * scale_factor.y, maxf(0, window.end.x - overlap.end.x) * scale_factor.x, maxf(0, window.end.y - overlap.end.y) * scale_factor.y)
