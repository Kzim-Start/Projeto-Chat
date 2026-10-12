class_name MagePortrait
extends Control

var element: int = 0
var outfit := Vector3i.ZERO
var _time: float = 0.0


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST


func _process(delta: float) -> void:
	_time += delta
	queue_redraw()


func _draw() -> void:
	var magic := PixelArt.accent(element)
	var middle := Vector2(size.x / 2, size.y * 0.84)
	# The portrait uses an altar, distant masonry, a rune halo and motes.
	draw_rect(Rect2(Vector2.ZERO, size), Color("101722"))
	for index in range(7):
		var width := 18 + index * 12
		draw_rect(Rect2(middle.x - width, 5 + index * 4, width * 2, size.y - 15 - index * 6), Color(magic, 0.014))
	for side in [-1, 1]:
		var x: float = middle.x + side * size.x * 0.41
		draw_rect(Rect2(x - 6, size.y * 0.2, 12, size.y * 0.64), Color("242939"))
		draw_rect(Rect2(x - 9, size.y * 0.2, 18, 4), Color("4d485b"))
		for y in range(int(size.y * 0.3), int(size.y * 0.8), 18):
			draw_line(Vector2(x-5,y),Vector2(x+5,y),Color("161e2c"),2)
	draw_set_transform(middle,0,Vector2(1,0.28))
	draw_circle(Vector2.ZERO,size.x*0.40,Color("2c2c3c"))
	draw_arc(Vector2.ZERO,size.x*0.38,0,TAU,40,Color("716277"),2)
	draw_arc(Vector2.ZERO,size.x*0.29,0,TAU,40,Color(magic,0.32),2)
	for rune in range(8):
		var p := Vector2.from_angle(rune*TAU/8) * size.x*0.34
		draw_rect(Rect2(p,Vector2(3,4)),Color(magic,0.5))
	draw_set_transform(Vector2.ZERO)
	var zoom := maxf(1,floorf(minf(size.x/96.0,size.y/112.0)))
	var dimensions := PixelArt.SIZE*zoom
	var top := Vector2((size.x-dimensions.x)/2,middle.y-dimensions.y*0.90).floor()
	draw_texture_rect(PixelArt.mage(element,int(_time*6),outfit),Rect2(top,dimensions),false)
	for mote in range(7):
		var point := Vector2(fposmod(mote*43+17,size.x),size.y-fposmod(_time*9+mote*33,size.y))
		draw_rect(Rect2(point.floor(),Vector2(2,2)),Color(magic,0.35))
