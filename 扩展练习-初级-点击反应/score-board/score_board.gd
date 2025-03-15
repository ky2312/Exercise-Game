extends Control

@onready var score_node: Label = $VBoxContainer/Label2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score_node.text = "总分"+ str(GameManager.score)


func _on_reload_game() -> void:
	GameManager.command_reload_game()
