extends VBoxContainer

@onready var h_slider: HSlider = $HBoxContainer/HSlider

func _ready() -> void:
	var setting_model = GameManager.app.get_model(SettingModel) as SettingModel
	setting_model.volume.register_with_init_value(
		func(volume):
			h_slider.value = volume
	).unregister_when_node_exit_tree(self)


func _on_h_slider_value_changed(value: float) -> void:
	GameManager.app.send_command(VolumeChangeCommand.new(value))
