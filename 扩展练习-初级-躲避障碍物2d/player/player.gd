extends CharacterBody2D
class_name Player

@onready var particles: GPUParticles2D = $Particles
const SPEED = 300.0
const WIDTH = 30

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	var viewport_size = get_viewport_rect().size
	var direction := Input.get_axis("left", "right")
	var motion = Vector2.ZERO
	if direction:
		motion.x = direction * SPEED * delta
	else:
		motion.x = move_toward(velocity.x, 0, SPEED) * delta

	move_and_collide(motion)
	
	# 修正超出屏幕
	if self.position.x <= WIDTH / 2:
		self.position.x = WIDTH / 2
	elif self.position.x >= viewport_size.x - WIDTH / 2:
		self.position.x = viewport_size.x - WIDTH / 2
	move_and_slide()

func touch():
	particles.restart()
	GameCommand.hp_change()
