extends CanvasLayer

@onready var score_node: Label = $VBoxContainer/Label
@onready var countdown_node: Label = $VBoxContainer/Label2

func _ready() -> void:
	_show_score_label()
	_show_countdown_label()
	GameManager.score_changed.connect(_show_score_label)
	GameManager.countdown_changed.connect(_show_countdown_label)

func _show_score_label():
	score_node.text = "分数"+ str(GameManager.score)

func _show_countdown_label():
	countdown_node.text = "剩余时间"+ str(GameManager.countdown) +"秒"

func _on_countdown_timeout() -> void:
	if GameManager.countdown <= 0:
		get_tree().change_scene_to_file("res://score-board/score_board.tscn")
		return
	GameManager.command_minus_countdown()
