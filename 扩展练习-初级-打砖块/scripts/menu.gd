extends Control

@export var home: PackedScene

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(home)


func _on_end_button_pressed() -> void:
	get_tree().quit(0)
