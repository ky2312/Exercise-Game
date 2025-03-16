extends Control
class_name TextControl

signal click

@export_multiline var text: String
@onready var text_label: RichTextLabel = $Panel/Text
var _is_entered: bool = false

func _ready() -> void:
	self.refresh()

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and self._is_entered:
		click.emit()

func refresh():
	text_label.text = text

func _on_mouse_entered() -> void:
	self._is_entered = true

func _on_mouse_exited() -> void:
	self._is_entered = false
