extends CharacterBody2D
class_name Player

const SPEED = 300.0

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func touch():
	GameCommand.hp_change()
