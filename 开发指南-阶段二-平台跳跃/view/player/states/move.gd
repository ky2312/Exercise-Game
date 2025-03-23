extends LimboState

func _update(delta: float) -> void:
	var ag: Player = agent
	var moved = ag.move()
	if not ag.is_on_floor():
		ag.fall()
	elif Input.is_action_pressed("roll"):
		get_root().dispatch("roll")
	elif moved:
		get_root().dispatch("idle")
	elif Input.is_action_pressed("jump"):
		get_root().dispatch("jump")
