extends Node2D
class_name Wood

signal touch
signal screen_exited

var speed = 1

func init(origin_pos: Vector2, _speed: int):
	position = origin_pos
	speed = _speed
	
func _physics_process(delta: float) -> void:
	if visible:
		position += Vector2.LEFT * speed * delta


func _on_area_2d_body_entered(body: Node2D) -> void:
	touch.emit()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	screen_exited.emit()
