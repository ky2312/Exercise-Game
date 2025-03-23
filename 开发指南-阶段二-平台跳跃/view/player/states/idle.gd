extends LimboState

func _update(delta: float) -> void:
	var dir = Input.get_axis("left", "right")
	if dir != 0:
		get_root().dispatch("move")
	elif Input.is_action_pressed("jump"):
		get_root().dispatch("jump")
