extends CharacterBody2D
class_name Baffle

signal emitted(ball: Ball)

var speed: int = 600
@onready var ball_enter_marker: Marker2D = $BallEnterMarker
var current_ball: Ball

func _ready() -> void:
	speed *= Global.get_level_scene().difficult

func get_ball_enter_marker() -> Vector2:
	return ball_enter_marker.position

func set_current_ball(ball: Ball):
	current_ball = ball
	current_ball.position = get_ball_enter_marker()
	add_child(current_ball)

func _physics_process(delta: float) -> void:
	var dir: Vector2
	if Input.is_action_pressed("move_left"):
		dir = Vector2.LEFT
	elif Input.is_action_pressed("move_right"):
		dir = Vector2.RIGHT
	velocity = dir * speed * delta
	move_and_collide(velocity)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("space"):
		if current_ball:
			remove_child(current_ball)
			emitted.emit(current_ball)
			current_ball = null
