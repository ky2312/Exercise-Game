extends Control

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		_to_next_scene()

func _to_next_scene():
	var error = get_tree().change_scene_to_file("res://main/main.tscn")
	if error != OK:
		push_error(error)
