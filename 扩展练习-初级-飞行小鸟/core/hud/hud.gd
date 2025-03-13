extends CanvasLayer

signal game_start
signal game_end

class ControlPage:
	var node: Control
	var is_show: bool
	func _init(node: Control, is_show: bool):
		self.node = node
		self.is_show = is_show

@onready var node_menu = $Menu
@onready var node_menu_main = $Menu/Main
@onready var node_menu_button_game_start = $Menu/Main/ButtonGroup/StartButton
@onready var node_menu_button_setting = $Menu/Main/ButtonGroup/SettingButton
@onready var node_menu_button_game_end = $Menu/Main/ButtonGroup/EndButton
@onready var node_menu_setting = $Menu/Setting
@onready var node_menu_button_setting_level = $Menu/Setting/Level
@onready var node_menu_settinglevel = $Menu/SettingLevel
@onready var node_menu_back = $Menu/BackButton
var choose_cache_node_menu_main_control: Array = []
@onready var node_menu_main_control: Array[ControlPage] = [
	ControlPage.new(node_menu_main, true),
	ControlPage.new(node_menu_setting, false),
	ControlPage.new(node_menu_settinglevel, false),
	ControlPage.new(node_menu_back, false),
]
@onready var node_menu_setting_control: Array[ControlPage] = [
	ControlPage.new(node_menu_main, false),
	ControlPage.new(node_menu_setting, true),
	ControlPage.new(node_menu_settinglevel, false),
	ControlPage.new(node_menu_back, true)
]
@onready var node_menu_setting_level_control: Array[ControlPage] = [
	ControlPage.new(node_menu_main, false),
	ControlPage.new(node_menu_setting, false),
	ControlPage.new(node_menu_settinglevel, true),
	ControlPage.new(node_menu_back, true)
]
@onready var node_playing = $Playing
@onready var node_playing_level = $Playing/Level
@onready var node_playing_score = $Playing/Score
@onready var node_game_end = $GameEnd
@onready var node_game_end_button_game_start = $GameEnd/ButtonGroup/StartButton
@onready var node_game_end_button_game_end = $GameEnd/ButtonGroup/EndButton
@onready var node_game_end_button_home = $GameEnd/ButtonGroup/HomeButton

func show_menu():
	node_menu.visible = true
	node_playing.visible = false
	node_game_end.visible = false

func show_playing():
	EventBus.emit("init_score")
	node_menu.visible = false
	node_playing.visible = true
	node_game_end.visible = false
	node_playing_level.text = "难度: " + Global.current_level.name

func show_game_end():
	node_menu.visible = false
	node_playing.visible = false
	node_game_end.visible = true
	
func update_score():
	node_playing_score.text = str(Global.score)

func _init_level_button():
	var list = Global.levels
	var pre_level_buttons = node_menu_settinglevel.get_children()
	node_menu_settinglevel.size.y = node_menu_settinglevel.size.y / len(pre_level_buttons) * len(list)
	for i in len(list):
		var n = list[i]
		var pre_n = pre_level_buttons[i]
		pre_n.show()
		pre_n.text = n.name
		pre_n.connect("pressed", func(): 
			Global.current_level = n
			_control_back()
		)
	
func _ready() -> void:
	node_menu_button_game_start.connect("pressed", _on_game_start)
	node_menu_button_game_end.connect("pressed", _on_game_end)
	node_menu_button_setting.connect("pressed", _on_setting)
	node_menu_button_setting_level.connect("pressed", _on_setting_level)
	node_menu_back.connect("pressed", _on_back)
	node_game_end_button_game_start.connect("pressed", _on_game_start)
	node_game_end_button_game_end.connect("pressed", _on_game_end)
	node_game_end_button_home.connect("pressed", _on_home)
	EventBus.on("update_score", update_score)
	_init_level_button()
	_on_home()
	
func _exit_tree() -> void:
	EventBus.off("update_score", update_score)
	
func _control_display(list: Array[ControlPage]):
	for n in list:
		if n.is_show:
			n.node.show()
		else:
			n.node.hide()
func _control_next(list: Array[ControlPage]):
	choose_cache_node_menu_main_control.append(list)
	_control_display(list)
func _control_back():
	choose_cache_node_menu_main_control.pop_back()
	_control_display(choose_cache_node_menu_main_control[len(choose_cache_node_menu_main_control) - 1])
func _control_clear():
	choose_cache_node_menu_main_control.clear()

func _on_home():
	_control_clear()
	show_menu()
	_control_next(node_menu_main_control)

func _on_game_start() -> void:
	show_playing()
	game_start.emit()


func _on_game_end() -> void:
	game_end.emit()


func _on_back() -> void:
	_control_back()

func _on_setting() -> void:
	_control_next(node_menu_setting_control)


func _on_setting_level() -> void:
	_control_next(node_menu_setting_level_control)
