extends LimboState

func _enter() -> void:
	agent.jump()

func _update(delta: float) -> void:
	if not agent.is_on_floor():
		agent.velocity += agent.get_gravity() * delta
	else:
		get_root().dispatch("move")
	var moved = agent.move()
