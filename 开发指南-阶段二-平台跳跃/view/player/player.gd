extends CharacterBody2D
class_name Player

@onready var sprite_node: AnimatedSprite2D = $AnimatedSprite2D
var jump_velocity = -250.0
var speed = 150.0
var roll_speed = 300

#var is_on_ladder: bool = false

var fsm: FSM

func _init() -> void:
	fsm = FSM.new()
	fsm.set_database("node", self)
	fsm.set_database("jump_velocity", jump_velocity)
	fsm.set_database("speed", speed)
	fsm.set_database("roll_speed", roll_speed)
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
	fsm.set_init("root/idle")
	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	fsm.update(delta)
	move_and_slide()
	#print("当前状态 {0} {1}".format([fsm.current_state_name, fsm.current_state and !!fsm.current_state.parent]))

func _unhandled_input(event: InputEvent) -> void:
	fsm.input(event)

class RootState extends FSM.State:
	func update(delta):
		var direction := Input.get_axis("left", "right")
		
		match direction:
			1.0:
				context.database.node.sprite_node.flip_h = false
			-1.0:
				context.database.node.sprite_node.flip_h = true

class IdleState extends FSM.State:
	func enter():
		context.database.node.sprite_node.play("idle")
	
	func input(event):
		if event.is_action_pressed("jump"):
			context.change_state("root/jump")
		elif event.is_action_pressed("left", true) or event.is_action_pressed("right", true):
			context.change_state("root/move")
	
	func exit():
		print("退出空闲")

class MoveState extends FSM.State:
	func enter():
		context.database.node.sprite_node.play("move")
		
	func update(delta):
		var direction := Input.get_axis("left", "right")
		
		if direction:
			context.database.node.velocity.x = direction * context.database.speed
		else:
			context.database.node.velocity.x = move_toward(context.database.node.velocity.x, 0, context.database.speed)
	
	func input(event):
		if event.is_action_pressed("roll"):
			context.change_state("root/roll")
		elif event.is_action_pressed("jump"):
			context.change_state("root/jump")
		elif not (event.is_action_pressed("left", true) or event.is_action_pressed("right", true)):
			context.database.node.velocity.x = 0.0
			context.change_state("root/idle")
	
class JumpState extends FSM.State:
	func enter():
		context.change_state("root/air/rising")
	
class AirState extends FSM.State:
	func enter():
		context.database.node.sprite_node.play("jump")
		
	func exit():
		context.database.node.velocity.x = 0.0

class AirRisingState extends FSM.State:
	func enter():
		context.database.node.velocity.y = context.database.jump_velocity
	
	func update(delta):
		var direction := Input.get_axis("left", "right")
		
		if direction:
			context.database.node.velocity.x = direction * context.database.speed
		else:
			context.database.node.velocity.x = move_toward(context.database.node.velocity.x, 0, context.database.speed)
		
		if context.database.node.velocity.y > 0:
			context.change_state("root/air/falling")

class AirFallingState extends FSM.State:
	func update(delta):
		var direction := Input.get_axis("left", "right")
		
		if direction:
			context.database.node.velocity.x = direction * context.database.speed
		else:
			context.database.node.velocity.x = move_toward(context.database.node.velocity.x, 0, context.database.speed)

		if context.database.node.is_on_floor():
			if context.database.node.velocity.x != 0.0:
				context.change_state("root/move")
			else:
				context.change_state("root/idle")

class RollState extends FSM.State:
	func enter():
		context.database.node.sprite_node.play("roll")
		context.database.roll_timer = 0.3
		context.database.direction = Input.get_axis("left", "right")
		
	func update(d):
		if context.database.direction == 1.0:
			context.database.node.velocity.x = context.database.roll_speed
		elif context.database.direction == -1.0:
			context.database.node.velocity.x = -1 * context.database.roll_speed
	
		context.database.roll_timer -= d
		if context.database.roll_timer <= 0.0:
			context.change_state("root/move")
		
	func exit():
		context.database.node.velocity.x = context.database.speed
