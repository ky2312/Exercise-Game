extends Node

var app: Framework

func _ready() -> void:
	app = Framework.new()
	app.register_model(MobModel)
	app.register_model(PlayerModel)
	app.run()
