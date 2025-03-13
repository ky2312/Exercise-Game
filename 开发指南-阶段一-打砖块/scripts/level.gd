extends Node2D

@export var ball: PackedScene
@onready var baffle: Baffle = $Baffle

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var ball = ball.instantiate()
	baffle.set_current_ball(ball)

func _on_baffle_emitted(ball: Ball) -> void:
	ball.position = baffle.position + baffle.get_ball_enter_marker()
	ball.hit(Vector2.UP)
	add_child(ball)
