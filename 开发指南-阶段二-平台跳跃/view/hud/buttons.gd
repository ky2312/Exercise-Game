extends VBoxContainer


func _on_save_button_pressed() -> void:
	GameManager.app.send_command(GameSaveCommand.new())


func _on_load_button_pressed() -> void:
	GameManager.app.send_command(GameLoadCommand.new())
