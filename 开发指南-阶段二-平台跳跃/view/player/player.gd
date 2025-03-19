extends CharacterBody2D
class_name Player

@onready var sprite_node: AnimatedSprite2D = $AnimatedSprite2D
#var jump_velocity = -250.0
var is_on_ladder: bool = false

var btm: BT.BTManager

func _ready() -> void:
	var btcontext = BT.BTContext.new()
	var animated_sprite = BT.AnimatedSprite.new(sprite_node)
	btcontext.animated_sprite = animated_sprite
	
	var root = BT.SelectorNode.new()
	
	var roll_group = BT.RollGroupNode.new().node
	root.children.push_back(roll_group)
	var jump_group = BT.JumpGroupNode.new().node
	root.children.push_back(jump_group)
	var move_group = BT.MoveGroupNode.new().node
	root.children.push_back(move_group)
	
	btm = BT.BTManager.new(btcontext)
	btm.set_root(root)

func _physics_process(delta: float) -> void:
	# 重力速度
	#if not is_on_floor():
		#velocity += get_gravity() * delta

	# 跳跃速度
	#if Input.is_action_just_pressed("jump") and is_on_floor():
		#velocity.y = jump_velocity

	var status = btm.tick(self)
	# 左右
	#var direction := Input.get_axis("left", "right")
		
	# 左右速度
	#if direction:
		#velocity.x = direction * speed
	#else:
		#velocity.x = move_toward(velocity.x, 0, speed)
	#
	## 滚动速度
	#if direction and Input.is_action_just_pressed("roll") and not is_rolling:
		#is_rolling = true
		#roll_timer = roll_duration
	#if is_rolling:
		#roll_timer -= delta
		#if roll_timer <= 0:
			#is_rolling = false
			#roll_timer = 0
		#else:
			#velocity.x = direction * roll_speed
	
	move_and_slide()

func set_on_ladder(v: bool):
	is_on_ladder = v
