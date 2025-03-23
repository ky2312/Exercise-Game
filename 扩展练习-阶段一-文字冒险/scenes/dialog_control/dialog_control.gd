extends CanvasLayer
class_name DialogControl

@onready var select_container_node: VBoxContainer = %SelectContainer
var _section: Section
@onready var _left: AvatarControl = %AvatarControl
@onready var _text: TextControl = %TextControl
@onready var _right: AvatarControl = %AvatarControl2

func bind_section(section: Section):
	self._section = section
	self._refresh()

func _on_text_click():
	if self._section.buttons:
		self.select_container_node.show()
	elif self._section.next:
		self._section_change(self._section.next)
	else:
		self._section.finish.emit()

func _section_change(section: Section):
	self._section = section
	self._refresh()

func _refresh():
	self._left.hide_node()
	self._right.hide_node()
	
	if self._section.avatar:
		match self._section.avatar.direction:
			Section.Avatar.DIRECTION_LEFT:
				self._left.image = self._section.avatar.image
				self._left.avatar_name = self._section.avatar.avatar_name
				self._left.refresh()
			Section.Avatar.DIRECTION_RIGHT:
				self._right.image = self._section.avatar.image
				self._right.avatar_name = self._section.avatar.avatar_name
				self._right.refresh()
	
	self._text.text = self._section.text
	self._text.refresh()
	
	if self._section.buttons:
		for key in self._section.buttons:
			var btn = Button.new()
			btn.text = key
			btn.pressed.connect(func():
				var c: Callable = self._section.buttons.get(key)
				c.call()
				self.select_container_node.hide()
				if self._section.next:
					self._section_change(self._section.next)
				else:
					self._section.finish.emit()
			)
			self.select_container_node.add_child(btn)
