class_name SettingModel extends FrameworkIModel

var volume := FrameworkBindableProperty.new(100.0)

func on_init():
	GameManager.app.audio.set_volume(volume.value)
