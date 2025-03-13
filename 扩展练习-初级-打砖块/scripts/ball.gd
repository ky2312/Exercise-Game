extends CharacterBody2D
class_name Ball

@onready var speed: int = 500

func _ready() -> void:
	speed *= Global.get_level_scene().difficult

func hit(direction: Vector2):
	velocity = direction * speed

func _physics_process(delta: float) -> void:
	# 限制速度
	velocity = Vector2(clamp(velocity.x, -speed, speed), clamp(velocity.y, -speed, speed))
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	if collision:
		# 获取碰撞对象
		var collider = collision.get_collider()
		if collider is Baffle:
			collider = (collider as Baffle)
			# 叠加碰撞对象速度到小球
			velocity += collision.get_collider_velocity() / 2
		# 剩余量反射
		var reflect = collision.get_remainder().bounce(collision.get_normal())
		# 速度反射
		velocity = velocity.bounce(collision.get_normal())
		move_and_collide(reflect)
		
		# 砖块
		if collider is Brick:
			(collider as Brick).collision()
