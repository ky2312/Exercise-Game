extends BTAction

func _tick(delta: float) -> Status:
	var ag: CharacterBody2D = agent
	var check_left = blackboard.get_var("check_left")
	var check_right = blackboard.get_var("check_right")
	var speed = blackboard.get_var("speed")
	var dir = 0
	if check_left:
		dir = -1
	elif check_right:
		dir = 1
	if dir == 0:
		ag.velocity.x = 0
		return SUCCESS
	ag.velocity.x = dir * speed
	return RUNNING
