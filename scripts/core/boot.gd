extends Control


func _ready() -> void:
	_start.call_deferred()


func _start() -> void:
	if not GameManager.is_catalog_ready():
		$Status.text = "BOOT_ERROR"
		return
	if SceneManager.navigate_to(SceneManager.Page.FOUNDATION) != OK:
		$Status.text = "BOOT_ERROR"
