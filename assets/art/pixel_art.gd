class_name PixelArt
extends RefCounted
## Original layered pixel art. Integer pixels, nearest filtering, bounded cache.

const SIZE := Vector2(96, 112)
const INK := Color("111525")
const GOLD := Color("c8a66b")
const GOLD_LIGHT := Color("f5d99b")
static var _mages: Dictionary = {}
static var _icons: Dictionary = {}


static func accent(element: int) -> Color:
	return [Color("a3f5eb"), Color("ffbe71"), Color("d9c1ff")][clampi(element, 0, 2)]


static func mage(element: int, frame: int = 0, outfit: Vector3i = Vector3i.ZERO) -> Texture2D:
	element = clampi(element, 0, 2)
	frame = posmod(frame, 8)
	var key := "%d/%d/%s" % [element, frame, outfit]
	if _mages.has(key):
		return _mages[key]
	var canvas := Image.create(96, 112, false, Image.FORMAT_RGBA8)
	canvas.fill(Color.TRANSPARENT)
	var cloth: Color = [Color("397c91"), Color("a34348"), Color("7564ad")][element]
	var shade: Color = [Color("243a57"), Color("482d45"), Color("393251")][element]
	var light: Color = [Color("74bcbf"), Color("dd805c"), Color("b099d1")][element]
	var magic := accent(element)
	var sway: int = [0, 1, 2, 1, 0, -1, -2, -1][frame]
	var bob: int = 1 if frame in [2, 3, 4] else 0
	# Back cape: wide silhouette, scalloped hem and separate fabric planes.
	_poly(canvas, [29,45, 54,45, 63,63, 69+sway,94, 57,99, 46,95, 35,101, 15+sway,97, 23,64], INK)
	_poly(canvas, [29,48, 50,48, 62,80, 66+sway,92, 56,96, 46,91, 34,97, 19+sway,95, 25,64], shade)
	_poly(canvas, [29,50, 36,50, 30+sway,90, 22+sway,94, 26,66], cloth)
	_poly(canvas, [51,50, 56,54, 63+sway,91, 57,94, 54,68], cloth.darkened(0.18))
	_poly(canvas, [21+sway,91, 34,94, 44,89, 55,92, 63+sway,89, 64+sway,92, 56,96, 44,94, 35,98, 21+sway,95], GOLD.darkened(0.32))
	# Boots and inner tunic remain readable beneath the outer coat.
	_poly(canvas, [30,88, 40,88, 39,105, 25,105, 25,102, 29,99], INK)
	_poly(canvas, [44,89, 53,89, 55,100, 60,103, 60,106, 44,106], INK)
	_rect(canvas, 30,96,8,5,Color("564c57"))
	_rect(canvas, 46,97,7,5,Color("514451"))
	_rect(canvas, 26,103,11,1,GOLD.darkened(0.25))
	_rect(canvas, 46,104,12,1,GOLD.darkened(0.25))
	_poly(canvas, [30,49, 53,49, 60,91, 46,98, 39,94, 28,95, 25,89], INK)
	_poly(canvas, [33,54, 50,54, 55,89, 46,94, 39,90, 29,92], cloth)
	_poly(canvas, [40,57, 46,57, 50,91, 43,93, 38,88], shade.darkened(0.10))
	_poly(canvas, [30,56, 37,54, 35,86, 29,90], light.darkened(0.18))
	_poly(canvas, [48,55, 52,58, 57,88, 53,91], cloth.darkened(0.22))
	_rect(canvas, 32,70,22,4,Color("372b36"))
	_rect(canvas, 33,70,20,1,GOLD)
	_rect(canvas, 41,70,5,5,GOLD)
	_rect(canvas, 42,71,3,2,INK)
	# Sleeves, gloves and draped shoulder collar, with pixel highlights.
	_poly(canvas, [29,49, 24,53, 20,67, 24,74, 30,74, 33,60], INK)
	_poly(canvas, [28,52, 25,56, 23,66, 25,70, 29,68, 31,57], cloth)
	_rect(canvas, 23,67,7,3,GOLD)
	_rect(canvas, 25,71,5,5,Color("b48c80"))
	_rect(canvas, 25,74,5,3,shade)
	_poly(canvas, [52,49, 59,51, 68,65, 77,63, 80,68, 68,73, 56,65], INK)
	_poly(canvas, [54,52, 58,54, 69,68, 76,65, 76,69, 68,70, 58,63], cloth)
	_rect(canvas, 70,64,3,7,GOLD)
	_poly(canvas, [24,50, 32,44, 51,43, 60,50, 55,59, 43,54, 31,59], INK)
	_poly(canvas, [27,50, 33,47, 48,46, 56,50, 53,55, 43,51, 32,55], light)
	_poly(canvas, [28,54, 34,51, 41,54, 35,58], cloth)
	_line(canvas, Vector2i(44,53), Vector2i(53,58), GOLD)
	_line(canvas, Vector2i(32,56), Vector2i(42,53), GOLD)
	# Face beneath the brim: lit cheeks and luminous eyes.
	_poly(canvas, [30,30+bob, 51,29+bob, 56,39+bob, 50,48+bob, 36,49+bob, 28,42+bob], INK)
	_poly(canvas, [33,35+bob, 49,34+bob, 51,41+bob, 47,46+bob, 36,45+bob], Color("413945"))
	_rect(canvas, 34,40+bob,4,3,Color("ae9ba0"))
	_rect(canvas, 45,40+bob,4,3,Color("857887"))
	_rect(canvas, 33,37+bob,6,2,magic.darkened(0.18))
	_rect(canvas, 44,37+bob,6,2,magic.darkened(0.18))
	_rect(canvas, 35,37+bob,3,1,Color("effffa"))
	_rect(canvas, 45,37+bob,3,1,Color("effffa"))
	_rect(canvas, 40,40+bob,2,3,Color("be9e98"))
	_poly(canvas, [36,44+bob, 47,44+bob, 42,50+bob], Color("d6c9ba"))
	# Bent frost cap, ember hood and angular storm crown.
	if element == 0:
		_poly(canvas, [17,33+bob, 27,25+bob, 33,12+bob, 47,4+bob, 59,9+bob, 55,16+bob, 45,14+bob, 51,28+bob, 63,34+bob, 59,39+bob, 33,38+bob], INK)
		_poly(canvas, [23,33+bob, 30,26+bob, 36,14+bob, 47,7+bob, 56,10+bob, 53,13+bob, 42,11+bob, 45,21+bob, 49,30+bob, 59,34+bob, 57,35+bob, 34,35+bob], cloth)
		_poly(canvas, [29,28+bob, 36,15+bob, 46,9+bob, 41,16+bob, 38,29+bob], light)
		_poly(canvas, [43,15+bob, 48,27+bob, 55,31+bob, 43,30+bob], shade)
	elif element == 1:
		_poly(canvas, [22,34+bob, 24,22+bob, 29,13+bob, 33,8+bob, 41,16+bob, 50,11+bob, 57,22+bob, 60,35+bob, 52,42+bob, 48,33+bob, 32,32+bob, 29,42+bob], INK)
		_poly(canvas, [25,32+bob, 28,23+bob, 33,13+bob, 40,21+bob, 49,15+bob, 54,23+bob, 56,34+bob, 52,36+bob, 49,29+bob, 31,29+bob, 28,36+bob], cloth)
		_poly(canvas, [28,27+bob, 33,17+bob, 36,22+bob, 33,28+bob], light)
		_poly(canvas, [45,22+bob, 49,19+bob, 53,27+bob, 50,30+bob], shade)
		_line(canvas, Vector2i(31,28+bob), Vector2i(49,28+bob), GOLD, 2)
	else:
		_poly(canvas, [21,32+bob, 28,22+bob, 29,13+bob, 38,7+bob, 43,13+bob, 51,5+bob, 51,20+bob, 57,30+bob, 63,34+bob, 55,39+bob, 28,37+bob], INK)
		_poly(canvas, [26,32+bob, 32,23+bob, 32,15+bob, 38,11+bob, 43,19+bob, 48,12+bob, 48,23+bob, 54,32+bob, 58,34+bob, 52,35+bob, 31,34+bob], cloth)
		_poly(canvas, [33,24+bob, 37,15+bob, 40,23+bob, 39,31+bob, 31,32+bob], light)
		_poly(canvas, [43,22+bob, 47,17+bob, 47,28+bob, 51,33+bob, 43,32+bob], shade)
	_line(canvas, Vector2i(28,31+bob), Vector2i(53,33+bob), GOLD.darkened(0.1), 2)
	_gem(canvas, Vector2i(40,31+bob), magic, 3)
	for y in [59, 63, 67]:
		_rect(canvas, 42,y,2,1,GOLD_LIGHT)
	for y in range(78,90,4):
		_line(canvas, Vector2i(32,y), Vector2i(35,y+2), GOLD.darkened(0.22))
		_rect(canvas, 51,y+1,2,1,light)
	# Equipment layers preserve the character's elemental silhouette.
	if outfit.y > 0:
		_line(canvas, Vector2i(28,60), Vector2i(23+sway,90), GOLD_LIGHT)
		_line(canvas, Vector2i(56,60), Vector2i(62+sway,90), GOLD_LIGHT)
		for y in range(66,89,7):
			_gem(canvas, Vector2i(27+sway,y), magic, 2)
		if outfit.y == 2:
			_poly(canvas, [25,49, 25,43, 31,46, 35,49, 33,52], GOLD)
			_poly(canvas, [52,48, 56,43, 60,46, 59,52, 55,54], GOLD)
			for y in range(62,92,6):
				_rect(canvas, 57+sway,y,2,2,magic.darkened(0.16))
	if outfit.z > 0:
		_line(canvas, Vector2i(35,51), Vector2i(43,59), GOLD)
		_line(canvas, Vector2i(50,51), Vector2i(43,59), GOLD)
		_gem(canvas, Vector2i(43,60), magic if outfit.z == 1 else GOLD_LIGHT, 3 if outfit.z == 1 else 4)
	_staff(canvas, element, outfit.x, bob)
	_rect(canvas, 76,65,5,4,Color("b99a91"))
	_rect(canvas, 76,65,4,1,Color("e4c5b0"))
	if _mages.size() >= 96:
		_mages.erase(_mages.keys()[0])
	_mages[key] = ImageTexture.create_from_image(canvas)
	return _mages[key]


static func _staff(canvas: Image, element: int, tier: int, bob: int) -> void:
	var magic := accent(element)
	_rect(canvas, 77,30+bob,5,75,INK)
	_rect(canvas, 78,32+bob,2,70,Color("75605b"))
	_rect(canvas, 78,41+bob,1,55,Color("b99976"))
	for y in [46, 61, 92, 99]:
		_rect(canvas, 76,y,6,2,GOLD)
	var radius := 5 + tier
	_poly(canvas, [71,31+bob, 70,22+bob, 73,16+bob, 76,20+bob, 75,29+bob, 83,29+bob, 84,20+bob, 87,16+bob, 89,22+bob, 86,32+bob, 82,35+bob, 75,35+bob], INK)
	_poly(canvas, [73,30+bob, 72,23+bob, 74,21+bob, 77,31+bob, 82,31+bob, 85,21+bob, 87,23+bob, 85,31+bob, 81,33+bob, 77,33+bob], GOLD)
	_gem(canvas, Vector2i(79,23+bob), magic, radius)
	if element == 1:
		_poly(canvas, [74,23+bob, 77,15+bob, 80,18+bob, 82,11+bob, 85,19+bob, 83,26+bob, 77,27+bob], Color("dd7555"))
		_poly(canvas, [77,24+bob, 80,18+bob, 82,22+bob, 80,26+bob], magic)
	elif element == 2:
		_poly(canvas, [79,12+bob, 83,13+bob, 80,21+bob, 84,21+bob, 77,31+bob, 79,24+bob, 75,24+bob], magic)
	if tier > 0:
		for y in range(45,90,9):
			_rect(canvas, 78,y,2,3,magic.darkened(0.15))
	if tier == 2:
		_line(canvas, Vector2i(69,21+bob), Vector2i(73,34+bob), GOLD_LIGHT, 2)
		_line(canvas, Vector2i(89,21+bob), Vector2i(85,34+bob), GOLD_LIGHT, 2)
		_gem(canvas, Vector2i(79,37+bob), magic, 3)


static func equipment_icon(slot: String, tier: int = 1) -> Texture2D:
	var key := slot + str(tier)
	if _icons.has(key):
		return _icons[key]
	var canvas := Image.create(40,40,false,Image.FORMAT_RGBA8)
	canvas.fill(Color.TRANSPARENT)
	var magic := Color("a6dcd7") if tier == 1 else Color("dac1ef")
	match slot:
		"staff":
			_line(canvas,Vector2i(10,33),Vector2i(26,10),INK,5)
			_line(canvas,Vector2i(10,33),Vector2i(26,10),GOLD,2)
			_poly(canvas,[19,11,19,5,23,9,30,12,34,9,33,16,27,19,23,16],GOLD)
			_gem(canvas,Vector2i(27,9),magic,6)
			if tier == 2:
				_gem(canvas,Vector2i(21,22),magic,3)
		"mantle":
			_poly(canvas,[13,7,26,7,30,14,35,33,23,36,18,32,7,35,9,17],INK)
			_poly(canvas,[14,9,25,9,28,17,32,31,24,33,19,29,10,32,12,18],Color("796086"))
			_poly(canvas,[14,11,19,12,16,28,11,31],Color("b1a0b8"))
			_line(canvas,Vector2i(12,31),Vector2i(16,14),GOLD)
			_line(canvas,Vector2i(30,31),Vector2i(24,14),GOLD)
			_gem(canvas,Vector2i(20,12),magic,3)
			if tier == 2:
				for y in [20,25,30]:
					_gem(canvas,Vector2i(25,y),GOLD_LIGHT,2)
		"amulet":
			_line(canvas,Vector2i(12,6),Vector2i(20,22),GOLD,2)
			_line(canvas,Vector2i(28,6),Vector2i(20,22),GOLD,2)
			_gem(canvas,Vector2i(20,26),GOLD,10)
			_gem(canvas,Vector2i(20,25),magic,7 if tier == 2 else 5)
	_icons[key] = ImageTexture.create_from_image(canvas)
	return _icons[key]


static func _gem(canvas: Image, at: Vector2i, color: Color, radius: int) -> void:
	_poly(canvas,[at.x,at.y-radius-1,at.x+radius+1,at.y,at.x,at.y+radius+1,at.x-radius-1,at.y],INK)
	_poly(canvas,[at.x,at.y-radius,at.x+radius,at.y,at.x,at.y+radius,at.x-radius,at.y],color.darkened(0.18))
	_poly(canvas,[at.x,at.y-radius,at.x,at.y+radius-1,at.x-radius+1,at.y],color)
	_rect(canvas,at.x-1,at.y-radius+2,2,2,Color("f5ffff"))


static func _line(canvas: Image, start: Vector2i, end: Vector2i, color: Color, width: int = 1) -> void:
	var count := maxi(absi(end.x-start.x),absi(end.y-start.y))
	for index in range(count+1):
		var point := Vector2(start).lerp(Vector2(end),float(index)/maxi(1,count)).round()
		_rect(canvas,int(point.x),int(point.y),width,width,color)


static func _poly(canvas: Image, coordinates: Array, color: Color) -> void:
	var points := PackedVector2Array()
	var lo := Vector2(canvas.get_width(),canvas.get_height())
	var hi := Vector2.ZERO
	for index in range(0,coordinates.size(),2):
		var point := Vector2(coordinates[index],coordinates[index+1])
		points.append(point)
		lo = lo.min(point)
		hi = hi.max(point)
	for y in range(maxi(0,int(lo.y)),mini(canvas.get_height(),int(hi.y)+1)):
		for x in range(maxi(0,int(lo.x)),mini(canvas.get_width(),int(hi.x)+1)):
			if Geometry2D.is_point_in_polygon(Vector2(x+0.5,y+0.5),points):
				canvas.set_pixel(x,y,color)


static func _rect(canvas: Image, x: int, y: int, w: int, h: int, color: Color) -> void:
	canvas.fill_rect(Rect2i(x,y,w,h).intersection(Rect2i(0,0,canvas.get_width(),canvas.get_height())),color)
