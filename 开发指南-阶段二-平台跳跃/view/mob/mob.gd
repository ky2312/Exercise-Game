extends CharacterBody2D

@onready var bt: BTPlayer = $BTPlayer
@onready var 左探测: RayCast2D = $左探测
@onready var 右探测: RayCast2D = $右探测

#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0
var model: MobModel

func _ready() -> void:
	model = GameManager.app.get_model(MobModel)
	bt.blackboard.set_var("speed", model.speed.value)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	bt.blackboard.set_var("check_left", !!左探测.get_collider())
	bt.blackboard.set_var("check_right", !!右探测.get_collider())
	
	move_and_slide()
