@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_autoload_singleton("EventBus", "res://addons/event-bus-plugin/event-bus.gd")


func _exit_tree() -> void:
	remove_autoload_singleton("EventBus")
