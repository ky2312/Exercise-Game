extends Node

@onready var timer: Timer = $Timer

func game_start():
	GameModel.score = 0
	GameModel.hp = GameModel.max_hp
	timer.start()
	EventBus.emit("game_started")
	Engine.time_scale = 1

func game_end():
	timer.stop()
	EventBus.emit("game_ended")
	print("游戏结束")
	Engine.time_scale = 0

func score_change():
	GameModel.score += 1
	EventBus.emit("score_changed")

func hp_change():
	GameModel.hp -= 1
	EventBus.emit("hp_changed")
	if GameModel.hp <= 0:
		GameCommand.game_end()

func _on_timer_timeout() -> void:
	score_change()
