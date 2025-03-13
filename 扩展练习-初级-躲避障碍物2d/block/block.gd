extends Area2D
class_name Block

func _on_body_entered(body: Node2D) -> void:
	GameCommand.hp_change()
