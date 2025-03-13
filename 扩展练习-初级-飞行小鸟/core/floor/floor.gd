extends Node2D

signal entered

func _on_area_2d_body_entered(body: Node2D) -> void:
	entered.emit()
