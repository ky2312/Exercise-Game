extends Area2D

@export_enum("top", "right", "bottom", "left") var direction = "bottom"
@onready var bounced: int = 300

func _on_ball_entered(ball: Ball) -> void:
	var new_val = ball.velocity.normalized()
	if new_val.x >= 0:
		new_val.y *= -1
	elif new_val.x < 0:
		new_val.x *= -1
	ball.hit(new_val)
