extends Node

var current_level_index: int = 0
var levels: Array[LevelResource] = []

var current_level: LevelResource:
	get():
		if current_level_index >= len(levels):
			return null
		return levels[current_level_index]
	set(v):
		var i = levels.find(v)
		if i == -1:
			printerr("设置的值错误")
		else:
			current_level_index = i

# 分数
var score = 0

func _enter_tree() -> void:
	EventBus.on("add_score", _on_add_score)
	EventBus.on("init_score", _on_init_score)

func _exit_tree() -> void:
	EventBus.off("add_score", _on_add_score)
	EventBus.off("init_score", _on_init_score)
	
func _on_add_score(score: int):
	self.score += score
	EventBus.emit("update_score")

func _on_init_score():
	self.score = 0
	EventBus.emit("update_score")
