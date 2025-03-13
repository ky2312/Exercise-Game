extends Node2D

@export var block: PackedScene
@onready var timer: Timer = $Timer
@onready var init_marker: Marker2D = $InitMarker
var blocks: Array[Block] = []
var speed = 300

func _ready() -> void:
	EventBus.on("game_started", _start)

func _exit_tree() -> void:
	for block in blocks:
		remove_child(block)
	EventBus.off("game_started", _start)

func _physics_process(delta: float) -> void:
	var viewport_rect = get_viewport_rect().size
	for block in blocks:
		block.position.y += speed * delta
	blocks = blocks.filter(func(block: Block): 
		if block.position.y < viewport_rect.y:
			return true
		block.queue_free()
	)


func _add_block() -> void:
	var block: Block = block.instantiate()
	# 可以使用路径实现
	var pos = init_marker.position
	pos.x = randf_range(0, get_viewport_rect().size.x - 70)
	block.position = pos
	blocks.append(block)
	add_child(block)

func _start():
	timer.start()
