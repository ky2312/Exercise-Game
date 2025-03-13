extends CanvasLayer

@onready var hp: ProgressBar = %Hp
@onready var score_label: Label = %Score
@onready var game_end: VBoxContainer = %GameEnd
@onready var reload_button: Button = %ReloadButton

func _ready() -> void:
	hp.max_value = GameModel.max_hp
	hp.value = GameModel.hp
	EventBus.on("score_changed", _show_score)
	EventBus.on("hp_changed", _show_hp)
	EventBus.on("game_ended", _game_end)

func _exit_tree() -> void:
	EventBus.off("score_changed", _show_score)
	EventBus.off("hp_changed", _show_hp)
	EventBus.off("game_ended", _game_end)

func _show_score():
	score_label.text = str(GameModel.score)

func _show_hp():
	hp.value = GameModel.hp

func _game_end():
	game_end.show()

func _reload() -> void:
	GameCommand.game_reload()
