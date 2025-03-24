extends Node

var app: Framework

func _ready() -> void:
	app = Framework.new()
	app.register_model(MobModel)
	app.register_model(PlayerModel)
	app.register_model(SettingModel)
	app.enable_audio()
	app.logger.set_level(FrameworkLogger.LEVEL.DEBUG)
	app.run(self)
