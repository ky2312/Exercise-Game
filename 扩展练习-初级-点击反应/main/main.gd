extends Node2D

@export var block_scene: PackedScene
#var is_start_add_block: bool = false

func _ready() -> void:
	_add_blocks()

#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("click"):
		#if not is_start_add_block:
			#is_start_add_block = true

func _add_blocks() -> void:
	for v in range(GameManager.add_block_total):
		var block = block_scene.instantiate()
		add_child(block)
