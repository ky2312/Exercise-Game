extends Control
class_name AvatarControl

@export var image: Texture2D
@export var avatar_name: String
@onready var avatar_image: Sprite2D = %AvatarImage
@onready var avatar_name_label: Label = %AvatarName

func _ready() -> void:
	self.refresh()

func refresh():
	if self.image:
		self.avatar_image.texture = image
		self.show_node()
		
	if self.avatar_name:
		self.avatar_name_label.text = self.avatar_name

func hide_node():
	self.avatar_image.hide()
	self.avatar_name_label.hide()

func show_node():
	self.avatar_image.show()
	self.avatar_name_label.show()
	
