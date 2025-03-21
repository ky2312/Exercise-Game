extends CharacterBody2D
class_name Player

@onready var sprite_node: AnimatedSprite2D = $AnimatedSprite2D
var jump_velocity = -250.0
var speed = 150.0

#var is_on_ladder: bool = false

var fsm: FSM

func _init() -> void:
	fsm = FSM.new()
	fsm.debugger = true
	fsm.set_data("node", self)
	fsm.set_data("jump_velocity", jump_velocity)
	fsm.set_data("speed", speed)
	var root_state = RootState.new()
	var idle_state = IdleState.new().bind_parent(root_state)
	var move_state = MoveState.new().bind_parent(root_state)
	var jump_state = JumpState.new().bind_parent(root_state)
	var air_state = AirState.new().bind_parent(root_state)
	var air_rising_state = AirRisingState.new().bind_parent(air_state)
	var air_falling_state = AirFallingState.new().bind_parent(air_state)
	var roll_state = RollState.new().bind_parent(root_state)
	fsm.add_states({
		"root": root_state,
		"root/idle": idle_state,
		"root/move": move_state,
		"root/jump": jump_state,
		"root/air": jump_state,
		"root/air/rising": air_rising_state,
		"root/air/falling": air_falling_state,
		"root/roll": roll_state,
	})

func _ready() -> void:
	fsm.init_state("root/idle")
	
func _physics_process(delta: float) -> void:	
	fsm.ui_update(delta)
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	fsm.ui_input(event)

class RootState extends FSM.State:
	func ui_update(delta):
		if not context.db.node.is_on_floor():
			context.db.node.velocity += context.db.node.get_gravity() * delta

		var direction := Input.get_axis("left", "right")
		
		match direction:
			1.0:
				context.db.node.sprite_node.flip_h = false
			-1.0:
				context.db.node.sprite_node.flip_h = true

class IdleState extends FSM.State:
	func enter():
		context.db.node.sprite_node.play("idle")
	
	func ui_input(event):
		if event.is_action_pressed("jump"):
			context.change_state("root/jump")
		elif event.is_action_pressed("left", true) or event.is_action_pressed("right", true):
			context.change_state("root/move")
	
	func exit():
		print("退出空闲")

class MoveState extends FSM.State:
	func enter():
		context.db.node.sprite_node.play("move")
		
	func ui_update(delta):
		var direction := Input.get_axis("left", "right")
		
		if direction:
			context.db.node.velocity.x = direction * context.db.speed
		else:
			context.db.node.velocity.x = move_toward(context.db.node.velocity.x, 0, context.db.speed)
	
	func ui_input(event):
		if event.is_action_pressed("roll"):
			context.change_state("root/roll")
		elif event.is_action_pressed("jump"):
			context.change_state("root/jump")
		elif not (event.is_action_pressed("left", true) or event.is_action_pressed("right", true)):
			context.db.node.velocity.x = 0.0
			context.change_state("root/idle")
	
class JumpState extends FSM.State:
	func enter():
		context.change_state("root/air/rising")
	
class AirState extends FSM.State:
	func enter():
		context.db.node.sprite_node.play("jump")
		
	func exit():
		context.db.node.velocity.x = 0.0

class AirRisingState extends FSM.State:
	func enter():
		context.db.node.velocity.y = context.db.jump_velocity
	
	func ui_update(delta):
		var direction := Input.get_axis("left", "right")
		
		if direction:
			context.db.node.velocity.x = direction * context.db.speed
		else:
			context.db.node.velocity.x = move_toward(context.db.node.velocity.x, 0, context.db.speed)
		
		if context.db.node.velocity.y > 0:
			context.change_state("root/air/falling")

class AirFallingState extends FSM.State:
	func ui_update(delta):
		var direction := Input.get_axis("left", "right")
		
		if direction:
			context.db.node.velocity.x = direction * context.db.speed
		else:
			context.db.node.velocity.x = move_toward(context.db.node.velocity.x, 0, context.db.speed)

		if context.db.node.is_on_floor():
			if context.db.node.velocity.x != 0.0:
				context.change_state("root/move")
			else:
				context.change_state("root/idle")

class RollState extends FSM.State:
	var _roll_speed: int
	
	var _roll_timer: float = 0.3
	
	var _direction: int
	
	func enter():
		context.db.node.sprite_node.play("roll")
		_roll_timer = 0.3
		_roll_speed = context.db.speed * 2
		_direction = Input.get_axis("left", "right")
		
	func ui_update(d):
		if _direction == 1.0:
			context.db.node.velocity.x = _roll_speed
		elif _direction == -1.0:
			context.db.node.velocity.x = -1 * _roll_speed
	
		_roll_timer -= d
		if _roll_timer <= 0.0:
			context.change_state("root/move")
		
	func exit():
		context.db.node.velocity.x = context.db.speed
