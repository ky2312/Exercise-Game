extends Node

var app: Framework.App

func _ready() -> void:
	app = Framework.App.new()
	app.run()
