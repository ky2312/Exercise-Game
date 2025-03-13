extends StaticBody2D
class_name Brick

const score: int = 1

func collision():
	Global.add_score(score)
	queue_free()
