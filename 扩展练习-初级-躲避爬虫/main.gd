extends Node

@export var mob_scene: PackedScene
var score: int

func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	
	
func new_game() -> void:
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Music.play()
	
	get_tree().call_group("mobs", "queue_free")
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#new_game()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_hit() -> void:
	game_over()


func _on_mob_timer_timeout() -> void:
	# 创建小怪
	var mob: RigidBody2D = mob_scene.instantiate()
	
	# 在Path2D上选择一个随机的位置
	var mob_spawn_location: PathFollow2D = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	# 设置小怪的位置
	mob.position = mob_spawn_location.position
	
	# 设置小怪的方向为路径方向的垂直方向
	var direction: float = mob_spawn_location.rotation + PI / 2
	
	# 在方向上添加随机性
	direction += randf_range(-PI / 4, PI/ 4)
	mob.rotation = direction

	# 设置小怪的速度
	var velocity: Vector2 = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	# 添加小怪
	add_child(mob)


func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)


func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()


func _on_hud_start_game() -> void:
	new_game()
