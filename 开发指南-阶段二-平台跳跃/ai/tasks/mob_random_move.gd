extends BTAction

var dir: int
var timer: float

func _enter() -> void:
	if randi_range(1, 10) % 2:
		dir = -1.0
	else:
		dir = 1.0
	timer = randf_range(0.5, 1.0)

func _tick(delta: float) -> Status:
	var ag: CharacterBody2D = agent
	var speed = blackboard.get_var("speed")
	
	timer -= delta
	if timer <= 0:
		ag.velocity.x = 0
		return SUCCESS
	ag.velocity.x = dir * speed / 2
	return RUNNING
