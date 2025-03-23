extends Node2D

@export var blocks: Array[PackedScene]
@onready var timer: Timer = $Timer
@onready var init_marker: Marker2D = $InitMarker
var block_list: Array[Block] = []
var speed = 200

func _ready() -> void:
	EventBus.on("game_started", _start)

func _exit_tree() -> void:
	for block in block_list:
		remove_child(block)
	EventBus.off("game_started", _start)

func _physics_process(delta: float) -> void:
	var viewport_rect = get_viewport_rect().size
	for block in block_list:
		block.position.y += block.speed * speed * delta
	block_list = block_list.filter(func(block: Block): 
		if block.position.y < viewport_rect.y:
			return true
		block.queue_free()
	)


func _add_block() -> void:
	var block: Block = blocks[randi_range(0, len(blocks) - 1)].instantiate()
	# 可以使用路径实现
	var pos = init_marker.position
	pos.x = randf_range(0, get_viewport_rect().size.x - 70)
	block.position = pos
	block_list.append(block)
	add_child(block)

func _start():
	timer.start()
