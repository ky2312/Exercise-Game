extends Area2D
class_name Block

## 下落速度
@export_range(1, 10, 1) var speed: int = 1
## 形状
@export_enum("正方形:1", "x长方形:2", "y长方形:3") var shape: int = 1

@onready var image: Sprite2D = $Icon
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	match shape:
		1:
			_set_rect(0.5, 0.5, 1, 1)
		2:
			_set_rect(1, 0.5, 2, 1)
		3:
			_set_rect(0.5, 1, 1, 2)

func _set_rect(a: float, b: float, c: float, d: float):
	image.scale.x = a
	image.scale.y = b
	collision_shape.scale.x = c
	collision_shape.scale.y = d

func _on_body_entered(body) -> void:
	if body is Player:
		body.touch()
