extends Node2D


@onready var block_manager: Node2D = $BlockManager
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameCommand.game_start()
