extends Node2D

## 默认等级下标
@export_range(0, 4) var current_level_index: int = 0
## 等级列表
## 从易到难
@export var levels: Array[LevelResource] = []

func game_start():
	$Bird.init($StartMarker.position)
	$Bird.show()
	$WoodManager.start()
	$GamePlayingTimer.start()

func game_over():
	$Bird.hide()
	$WoodManager.clear()
	$HUD.show_game_end()
	$GamePlayingTimer.stop()


func _enter_tree() -> void:
	if levels.is_empty():
		printerr("没有导入难度资源")
		get_tree().quit(1)
	
	Global.levels = levels
	Global.current_level_index = current_level_index

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	pass

func _on_hud_game_start() -> void:
	game_start()

func _on_hud_game_end() -> void:
	get_tree().quit()


func _on_game_playing_timer_timeout() -> void:
	EventBus.emitv("add_score", 1)


func _on_wood_manager_touch() -> void:
	game_over()


func _on_bird_exited() -> void:
	game_over()


func _on_floor_entered() -> void:
	game_over()
