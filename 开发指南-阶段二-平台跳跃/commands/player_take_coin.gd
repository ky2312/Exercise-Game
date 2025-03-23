class_name PlayerTakeCoin extends FrameworkICommand

func on_execute():
	var model := GameManager.app.get_model(PlayerModel) as PlayerModel
	model.have_coin.value += 1
