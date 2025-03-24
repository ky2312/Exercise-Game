extends Area2D

@export var audio: AudioStream
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_body_entered(body: Node2D) -> void:
	GameManager.app.send_command(PlayerTakeCoin.new())
	GameManager.app.audio.play_sfx(audio)
	animation_player.play("free")
