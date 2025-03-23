extends Node2D

@onready var camera: Camera2D = $Camera2D
@onready var player: Player = $Player

var m_1 = preload("res://assets/music/time_for_adventure.mp3")
var m_2 = preload("res://assets/sounds/coin.wav")
var m_3 = preload("res://assets/sounds/explosion.wav")

func _ready() -> void:
	Audio.play_background_music(m_1)

func _physics_process(delta: float) -> void:
	if (player):
		camera.position = player.position
