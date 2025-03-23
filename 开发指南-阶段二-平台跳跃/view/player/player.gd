extends CharacterBody2D
class_name Player

@onready var sprite_node: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_node: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hsm: LimboHSM = $HSM
@onready var idle_state: LimboState = $HSM/IdleState
@onready var move_state: LimboState = $HSM/MoveState
@onready var jump_state: LimboState = $HSM/JumpState
@onready var roll_state: LimboState = $HSM/RollState
@onready var climb_state: LimboState = $HSM/ClimbState

#var speed = 150.0
#var jump_velocity = -2.5 * speed
var model: PlayerModel
var delta: float
var need_gravity: float = true
var area: Area2D
var inner_ladder: bool = false

func _ready() -> void:
	model = GameManager.app.get_model(PlayerModel)
	
	hsm.add_transition(idle_state, move_state, "move")
	hsm.add_transition(idle_state, jump_state, "jump")
	hsm.add_transition(move_state, idle_state, "idle")
	hsm.add_transition(move_state, jump_state, "jump")
	hsm.add_transition(move_state, roll_state, "roll")
	hsm.add_transition(jump_state, move_state, "move")
	hsm.add_transition(roll_state, move_state, "move")
	hsm.add_transition(climb_state, move_state, "move")
	hsm.add_transition(climb_state, jump_state, "jump")
	
	hsm.initial_state = jump_state
	hsm.initialize(self)
	hsm.set_active(true)
	
func _physics_process(d: float) -> void:
	if model.is_killed.value:
		velocity = Vector2.ZERO
		return
	#print(hsm.get_active_state())
	delta = d
	compute_sprite_node_flip_h()
	hsm.update(d)
	move_and_slide()

func _unhandled_input(event):
	if inner_ladder:
		if event.is_action_pressed("up"):
			hsm.change_active_state(climb_state)
		elif event.is_action_pressed("down"):
			hsm.change_active_state(climb_state)

func move():
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * model.speed.value
	else:
		velocity.x = lerp(velocity.x, 0.0, 0.1)
	var is_moved = absf(velocity.x) < 1
	if is_moved:
		velocity.x = 0.0
	return is_moved

func jump():
	velocity.y = -1 * model.jump_velocity.value

func fall():
	velocity += get_gravity() * delta

func get_orientation() -> int:
	if sprite_node.flip_h:
		return -1.0
	else:
		return 1.0
	
func compute_sprite_node_flip_h():
	var direction := Input.get_axis("left", "right")
	match direction:
		1.0:
			sprite_node.flip_h = false
		-1.0:
			sprite_node.flip_h = true

func set_ladder_state(state: String, node: Area2D):
	match state:
		"enter":
			inner_ladder = true
			area = node
		"exit":
			inner_ladder = false
			area = node

func kill(node: Node2D):
	animation_player.play("kill")
	GameManager.app.send_command(PlayerKillCommand.new())
