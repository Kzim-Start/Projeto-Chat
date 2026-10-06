class_name PixelArt
extends RefCounted
## Original small-resolution art generated locally; no external asset dependency.

static var _mages: Dictionary = {}


static func mage(element: int, frame: int = 0) -> Texture2D:
	var key := Vector2i(element, frame % 4)
	if _mages.has(key):
		return _mages[key]
	var image := Image.create(40, 48, false, Image.FORMAT_RGBA8)
	image.fill(Color.TRANSPARENT)
	var primary: Color = [Color("5486a0"), Color("a84841"), Color("82619c")][clampi(element, 0, 2)]
	var light: Color = [Color("a8eeeb"), Color("ffbd73"), Color("d5baff")][clampi(element, 0, 2)]
	var dark := Color("171d31")
	var sway := [0, 1, 0, -1][frame % 4] as int
	for y in range(22, 43):
		var half_width := 5 + int((y - 22) * 0.43)
		_rect(image, 17 - half_width + sway, y, half_width * 2, 1, dark)
		_rect(image, 19 - half_width + sway, y, half_width * 2 - 4, 1, primary.darkened(float(y % 6) * 0.035))
	_rect(image, 13 + sway, 26, 3, 15, primary.lightened(0.18))
	_rect(image, 19, 26, 3, 15, primary.darkened(0.3))
	_rect(image, 11, 42, 6, 3, dark)
	_rect(image, 21, 42, 6, 3, dark)
	for y in range(8, 23):
		var width := 4 + int((y - 8) * 0.65)
		_rect(image, 17 - width, y, width * 2, 1, dark)
		_rect(image, 18 - width, y, width * 2 - 2, 1, primary)
	_rect(image, 10, 18, 15, 7, dark)
	_rect(image, 12, 22, 3, 2, light)
	_rect(image, 20, 22, 3, 2, light)
	_rect(image, 12, 26, 11, 2, Color("c8aa6a"))
	_rect(image, 15, 29, 4, 4, Color("d6ba79"))
	_rect(image, 17, 8, 2, 6, light)
	_rect(image, 29, 12, 2, 31, Color("715249"))
	_rect(image, 28, 30, 4, 3, Color("bc9274"))
	_rect(image, 27, 9, 6, 8, dark)
	_rect(image, 28, 7, 4, 10, light.darkened(0.15))
	_rect(image, 29, 9, 2, 6, Color("e7ffff"))
	_rect(image, 27, 18, 6, 2, Color("bb9861"))
	_mages[key] = ImageTexture.create_from_image(image)
	return _mages[key]


static func _rect(image: Image, x: int, y: int, w: int, h: int, color: Color) -> void:
	image.fill_rect(Rect2i(x, y, w, h).intersection(Rect2i(0, 0, image.get_width(), image.get_height())), color)
