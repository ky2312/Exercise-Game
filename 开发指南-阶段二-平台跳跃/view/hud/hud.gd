extends Control

@onready var coin: Label = %Coin
@onready var info: Label = %Info
var player_model: PlayerModel

func _ready() -> void:
	player_model = GameManager.app.get_model(PlayerModel) as PlayerModel
	player_model.have_coin.register_with_init_value(
		func(have_coin):
			coin.text = "已获取 {0} 枚硬币".format([str(have_coin)])
	).unregister_when_node_exit_tree(self)
	player_model.is_killed.register(
		func(is_killed):
			if is_killed:
				info.text = "玩家已死亡"
	)
