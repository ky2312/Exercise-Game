extends Node

signal score_changed

var _score: int = 0
var score: int:
	get(): return _score

func command_add_score():
	_score += 1
	score_changed.emit()

signal countdown_changed

var default_countdown: int = 60
## 倒计时
@export var _countdown: int = default_countdown
var countdown: int:
	get(): return _countdown

func command_minus_countdown():
	_countdown -= 1
	countdown_changed.emit()

## 添加方块的总数
@export var _add_block_total: int = 120
var add_block_total: int:
	get(): return _add_block_total

func command_reload_game():
	_score = 0
	_countdown = default_countdown
	get_tree().change_scene_to_file("res://start/start.tscn")

func _ready() -> void:
	default_countdown = _countdown
