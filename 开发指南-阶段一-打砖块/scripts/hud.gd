extends Control

@onready var level: Label = $VBox1/HBox1/Level
@onready var score: Label = $VBox1/HBox2/Score


func _physics_process(delta: float) -> void:
	level.text = str(Global.level)
	score.text = str(Global.score)
