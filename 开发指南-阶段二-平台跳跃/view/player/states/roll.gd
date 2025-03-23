extends LimboState

var direction: int

var roll_speed: int

var roll_timer: float

func _enter() -> void:
	var ag: Player = agent
	ag.velocity.x = 0.0
	roll_timer = 0.3
	roll_speed = ag.speed * 2
	direction = Input.get_axis("left", "right")
	
func _update(delta: float) -> void:
	var ag: Player = agent
	ag.velocity.x = direction * roll_speed

	roll_timer -= delta
	if roll_timer <= 0.0:
		get_root().dispatch("move")
