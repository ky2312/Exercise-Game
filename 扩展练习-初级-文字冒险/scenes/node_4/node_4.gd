extends Node2D

@onready var main_container: DialogControl = %MainContainer

func _ready() -> void:
	var section: Section = Section.new("进入节点四了")
	section = section.pipe(Section.new("获取%s个宝箱" % GameManager.have_treasure_box_total))\
	.pipe(Section.new("没有内容了"))
	section.finish.connect(_save_data)

	self.main_container.bind_section(section.to_top())

func _save_data():
	var c = ConfigFile.new()
	c.set_value("have", "have_treasure_box_total", GameManager.have_treasure_box_total)
	c.save("./data.cfg")
	
