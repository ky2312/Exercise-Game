class_name VolumeChangeCommand extends FrameworkICommand

var value: float

func _init(value: float) -> void:
	self.value = value
	
func on_execute():
	var model := GameManager.app.get_model(SettingModel) as SettingModel
	model.volume.value = value
	self.app.audio.set_volume(value)
