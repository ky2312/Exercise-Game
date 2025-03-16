extends Node2D

@onready var main_container: DialogControl = %MainContainer

func _ready() -> void:
	var section: Section = Section.new("进入节点二了", GameManager.user1_avatar)
	section = section.pipe(Section.new("获取一个宝物", GameManager.user1_avatar))
	section.finish.connect(func():
		GameManager.command_take_treasure_box()
		self.get_tree().change_scene_to_file("res://scenes/node_4/node_4.tscn")
	)

	self.main_container.bind_section(section.to_top())
