class_name PlayerKillCommand extends FrameworkICommand

func on_execute():
	var model := GameManager.app.get_model(PlayerModel) as PlayerModel
	model.is_killed.value = true
