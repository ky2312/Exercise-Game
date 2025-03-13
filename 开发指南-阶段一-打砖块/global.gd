extends Node

var _score: int = 0
var score: int:
	get:
		return _score

func add_score(v: int) -> void:
	_score += v
	if v == get_level_scene().total_score:
		next_level()

var _level: int = 1
var level: int:
	get:
		return _level
		
func game_over():
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")

func game_reset():
	_score = 0
	reset_level()

func game_back():
	_level = 1
	_score = 0
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

var _level_scenes: Array[Dictionary] = [
	{
		"res": "res://scenes/levels/level1.tscn",
		"total_score": 10,
		"difficult": 0.8,
	},
	{
		"res": "res://scenes/levels/level2.tscn",
		"total_score": 15,
		"difficult": 1,
	},
	{
		"res": "res://scenes/levels/level3.tscn",
		"total_score": 20,
		"difficult": 1.25,
	},
]

func get_level_scene():
	return _level_scenes[_level - 1]

func next_level():
	if _level >= len(_level_scenes):
		print("游戏完成")
		_level = 0
		_score = 0
		get_tree().change_scene_to_file(get_level_scene().res)
		return
	_level += 1
	get_tree().change_scene_to_file(get_level_scene().res)

func reset_level():
	get_tree().change_scene_to_file(get_level_scene().res)
