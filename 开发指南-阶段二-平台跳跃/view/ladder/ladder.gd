extends Area2D

@export_range(1, 10) var ladder_length: int = 3
@onready var tile_map_layer_node: TileMapLayer = $TileMapLayer
@onready var collision_shape_node: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	if ladder_length > 1:
		var from_position = Vector2i(0, 0)
		for v in range(ladder_length):
			var to_position = Vector2i(0, v)
			_copy_tile(from_position, to_position)
		_set_collision_shape()
	
	#self.body_entered.connect(func(node: Node2D):
		#if node is Player:
			#node.set_on_ladder(true)
	#)
	#self.body_exited.connect(func(node: Node2D):
		#if node is Player:
			#node.set_on_ladder(false)
	#)

func _copy_tile(from_position: Vector2i, to_position: Vector2i):
	var tile_id = tile_map_layer_node.get_cell_source_id(from_position)
	var atlas_coords = tile_map_layer_node.get_cell_atlas_coords(from_position)
	tile_map_layer_node.set_cell(to_position, tile_id, atlas_coords)

func _set_collision_shape():
	var h = tile_map_layer_node.tile_set.tile_size.y
	var shape = collision_shape_node.shape as RectangleShape2D
	shape.size.y = ladder_length * h
	collision_shape_node.position.y = shape.size.y / 2
