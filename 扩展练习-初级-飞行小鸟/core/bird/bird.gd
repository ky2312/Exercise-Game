extends CharacterBody2D
class_name Bird

signal exited

var viewport_size: Vector2
@onready var node_image = $Image
@onready var node_camera = $Camera2D

# 重力
const GRAVITY = 980
# 升力速度
const LIFT = 980 * 10
# 是否持续飞行
var is_keep_fly = false

func init(pos: Vector2):
	position = pos
	velocity = Vector2.ZERO

func _computed_camera():
	var camera_h = viewport_size.y / node_camera.zoom.y
	var camera_y = position.y - camera_h / 2 + node_camera.offset.y
	if camera_y <= 0:
		node_camera.offset.y += camera_y * -1
	elif node_camera.offset.y > 0 and camera_y + camera_h < viewport_size.y:
		node_camera.offset.y -= camera_y
		node_camera.offset.y = max(0, node_camera.offset.y)
	elif camera_y + camera_h >= viewport_size.y:
		node_camera.offset.y -= camera_y + camera_h - viewport_size.y
		

func _ready() -> void:
	viewport_size = get_viewport_rect().size
	
func _physics_process(delta: float) -> void:
	if visible:
		if is_keep_fly:
			velocity = Vector2.UP * LIFT * delta
		velocity += Vector2.DOWN * GRAVITY * delta
		
		_computed_camera()
		move_and_slide()
	
func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("fly"):
		is_keep_fly = true
		if not is_keep_fly:
			node_image.play("up")
		else:
			node_image.play("flap")
	else:
		is_keep_fly = false
		node_image.play("down")


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	exited.emit()
