extends CanvasLayer

func show_win() -> void:
	show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()
