extends CharacterBody2D
class_name Player

@onready var sprite_node: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_node: CollisionShape2D = $CollisionShape2D
var speed = 150.0
var jump_velocity = -2 * speed
var fsm: FSM

func _init() -> void:
	fsm = FSM.new()
	fsm.debugger = true
	fsm.set_data("node", self)
	fsm.set_data("jump_velocity", jump_velocity)
	fsm.set_data("speed", speed)
	fsm.set_data("inner_ladder", false)
	fsm.set_data("need_gravity", true)
	fsm.set_data("area", null)
	var root_state = RootState.new()
	var idle_state = IdleState.new().bind_parent(root_state)
	var move_state = MoveState.new().bind_parent(root_state)
	var jump_state = JumpState.new().bind_parent(root_state)
	var air_state = AirState.new().bind_parent(root_state)
	var air_rising_state = AirRisingState.new().bind_parent(air_state)
	var air_falling_state = AirFallingState.new().bind_parent(air_state)
	var roll_state = RollState.new().bind_parent(root_state)
	var climb_state = ClimbState.new().bind_parent(root_state)
	fsm.add_states({
		"root": root_state,
		"root/idle": idle_state,
		"root/move": move_state,
		"root/jump": jump_state,
		"root/air": jump_state,
		"root/air/rising": air_rising_state,
		"root/air/falling": air_falling_state,
		"root/roll": roll_state,
		"root/climb": climb_state,
	})

func _ready() -> void:
	fsm.init_state("root/idle")
	
func _physics_process(delta: float) -> void:	
	fsm.ui_update(delta)
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	fsm.ui_input(event)

func set_ladder_state(state: String, node: Area2D):
	match state:
		"enter":
			fsm.db.inner_ladder = true
			fsm.db.area = node
		"exit":
			fsm.db.inner_ladder = false
			fsm.db.area = node

class RootState extends FSM.State:
	func ui_update(delta):
		compute_gravity(delta)
		compute_sprite_node_flip_h()
	
	func ui_unhandled_input(event):
		if context.db.inner_ladder:
			if event.is_action_pressed("up"):
				context.change_state("root/climb")
			elif event.is_action_pressed("down"):
				context.change_state("root/climb")
	
	func compute_gravity(delta):
		if not context.db.node.is_on_floor() and context.db.need_gravity:
			context.db.node.velocity += context.db.node.get_gravity() * delta
	
	func compute_sprite_node_flip_h():
		var direction := Input.get_axis("left", "right")
		match direction:
			1.0:
				context.db.node.sprite_node.flip_h = false
			-1.0:
				context.db.node.sprite_node.flip_h = true

class IdleState extends FSM.State:
	func enter():
		context.db.node.velocity.x = 0.0
		context.db.node.sprite_node.play("idle")
	
	func ui_input(event):
		if event.is_action_pressed("jump"):
			context.change_state("root/jump")
		elif event.is_action_pressed("left", true) or event.is_action_pressed("right", true):
			context.change_state("root/move")
	
class MoveState extends FSM.State:
	var _to_idle = false
	
	var _to_roll = false
	
	func enter():
		context.db.node.sprite_node.play("move")
		
	func ui_update(delta):
		var end_move = context.db.node._move(context)
		if end_move:
			if _to_idle:
				context.change_state("root/idle")
		else:
			if _to_roll:
				context.change_state("root/roll")
	
	func ui_input(event):
		if event.is_action_pressed("roll"):
			#context.change_state("root/roll")
			_to_roll = true
		elif event.is_action_pressed("jump"):
			context.change_state("root/jump")
		elif not (event.is_action_pressed("left", true) or event.is_action_pressed("right", true)):
			#context.change_state("root/idle")
			_to_idle = true
	
	func exit():
		_to_idle = false
		_to_roll = false
 	
class JumpState extends FSM.State:
	func enter():
		context.change_state("root/air/rising")
	
class AirState extends FSM.State:
	func enter():
		context.db.node.sprite_node.play("jump")
		
class AirRisingState extends FSM.State:
	func enter():
		context.db.node.velocity.y = context.db.jump_velocity
	
	func ui_update(delta):
		var end_move = context.db.node._move(context)
		if context.db.node.velocity.y > 0.0:
			context.change_state("root/air/falling")
	
	func ui_input(event):
		if event.is_action_pressed("left", true) or event.is_action_pressed("right", true):
			context.change_state("root/move")

class AirFallingState extends FSM.State:
	func ui_update(delta):
		var end_move = context.db.node._move(context)
		if context.db.node.is_on_floor():
			context.change_state("root/move")

class RollState extends FSM.State:
	var _roll_speed: int
	
	var _roll_timer: float
	
	var _direction: int
	
	func enter():
		context.db.node.sprite_node.play("roll")
		context.db.node.velocity.x = 0.0
		_roll_timer = 0.3
		_roll_speed = context.db.speed * 2
		_direction = Input.get_axis("left", "right")
		
	func ui_update(d):
		context.db.node.velocity.x = _direction * _roll_speed
	
		_roll_timer -= d
		if _roll_timer <= 0.0:
			context.change_state("root/move")
		
	func exit():
		_roll_speed = 0
		_roll_timer = 0.0
		_direction = 0

class ClimbState extends FSM.State:
	var _speed: float
	
	func enter():
		var node: Player = context.db.node
		_speed = context.db.speed / 2
		node.velocity.x = 0
		context.db.need_gravity = false
		node.collision_layer = 2
		node.collision_mask = 2
		var area_node: Ladder = context.db.area
		var rect = area_node.get_rect()
		node.position.x = rect.position.x
	
	func ui_update(delta):
		var node: CharacterBody2D = context.db.node
		var direction := Input.get_axis("up", "down")
		context.db.node.velocity.y = direction * _speed
		
		if not context.db.inner_ladder:
			context.change_state("root/move")
	
	func exit():
		_speed = 0.0
		var node: CharacterBody2D = context.db.node
		context.db.need_gravity = true
		node.collision_layer = 3
		node.collision_mask = 3

func _move(context: FSM.Context) -> bool:
	var direction := Input.get_axis("left", "right")
	var _end_move = absf(context.db.node.velocity.x) <= 1
	if direction:
		context.db.node.velocity.x = direction * context.db.speed
	else:
		context.db.node.velocity.x = lerp(context.db.node.velocity.x, 0.0, 0.1)
	return _end_move
