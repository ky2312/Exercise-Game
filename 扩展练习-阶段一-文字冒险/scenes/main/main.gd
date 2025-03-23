extends Node2D

@onready var main_container: DialogControl = %MainContainer
var to_node2: bool

func _ready() -> void:
	var section: Section = Section.new("我是%s，现在进入对话系统，当前是节点一" % GameManager.user1_avatar.avatar_name, GameManager.user1_avatar)
	section = section.pipe(Section.new("ok，我是%s，有哪些可选项？" % GameManager.user2_avatar.avatar_name, GameManager.user2_avatar))\
	.pipe(Section.new("好的，有以下分支内容", GameManager.user1_avatar))\
	.add_buttons({
		"节点二": func(): to_node2 = true,
		"节点三": func(): to_node2 = false,
	})\
	.pipe(Section.new("马上进入下一节点", GameManager.user1_avatar))
	section.finish.connect(_scene_to_next_node)
	
	self.main_container.bind_section(section.to_top())

func _scene_to_next_node():
	if to_node2:
		get_tree().change_scene_to_file("res://scenes/node_2/node_2.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/node_3/node_3.tscn")
