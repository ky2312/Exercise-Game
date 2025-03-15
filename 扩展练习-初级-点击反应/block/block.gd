extends CharacterBody2D

@onready var blast: GPUParticles2D = %Blast
@onready var image: Sprite2D = $Image
@onready var animation: AnimationPlayer = $AnimationPlayer
var is_entered: bool = false

func _ready() -> void:
	self.input_pickable = true
	self._set_position()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		if is_entered:
			_click()

func _click():
	animation.play("blast")
	GameManager.command_add_score()
	get_viewport().set_input_as_handled()

func _set_position():
	var w = image.texture.get_width()
	var h = image.texture.get_height()
	var v_s = get_viewport_rect().size
	
	var pos_x = randi_range(w / 2, v_s.x - w / 2)
	var pos_y = randi_range(h / 2, v_s.y - h / 2)
	self.position = Vector2(pos_x, pos_y)

func _on_mouse_entered() -> void:
	is_entered = true

func _on_mouse_exited() -> void:
	is_entered = false
