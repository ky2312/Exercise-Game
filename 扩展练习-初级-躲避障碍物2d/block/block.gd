extends Area2D
class_name Block

func _on_body_entered(body) -> void:
	if body is Player:
		body.touch()
