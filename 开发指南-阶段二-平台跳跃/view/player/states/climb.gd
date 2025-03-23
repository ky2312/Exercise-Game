extends LimboState

var speed: float

func _enter() -> void:
	var ag: Player = agent
	speed = agent.speed / 2
	ag.velocity.x = 0
	ag.need_gravity = false
	ag.collision_layer = 2
	ag.collision_mask = 2
	var area: Ladder = ag.area
	var rect = area.get_rect()
	ag.position.x = rect.position.x

func _update(delta: float) -> void:
	var ag: Player = agent
	var direction = Input.get_axis("up", "down")
	ag.velocity.y = direction * speed
	
	if not ag.inner_ladder:
		get_root().dispatch("move")
	elif Input.is_action_pressed("jump"):
		ag.velocity.x = ag.get_orientation() * ag.speed
		get_root().dispatch("jump")

func _exit() -> void:
	var ag: Player = agent
	ag.need_gravity = true
	ag.collision_layer = 3
	ag.collision_mask = 3
