extends Node

signal save_treasure_box
var _have_treasure_box_total: int = 0
var have_treasure_box_total:
	get(): return _have_treasure_box_total

func command_take_treasure_box():
	_have_treasure_box_total += 1
	save_treasure_box.emit()

var user1_avatar = Section.Avatar.new("用户1", load("res://icon.svg"), Section.Avatar.DIRECTION_LEFT)

var user2_avatar = Section.Avatar.new("用户2", load("res://icon.svg"), Section.Avatar.DIRECTION_RIGHT)
