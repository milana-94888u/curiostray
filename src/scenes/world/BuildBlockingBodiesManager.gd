extends Node


@export var world: World


var blocking_shapes: Array[CollisionShape2D]


func _ready() -> void:
	BlockBreakManager.blocking_body_set.connect(add_shape)
	BlockBreakManager.blocking_body_removed.connect(remove_shape)


func add_shape(shape: CollisionShape2D) -> void:
	blocking_shapes.append(shape)


func remove_shape(shape: CollisionShape2D) -> void:
	blocking_shapes.erase(shape)


func shape_to_tiles(shape: CollisionShape2D) -> Array[Vector2i]:
	var shape_relative := world.to_local(shape.global_position)
	var shape_rect := shape.shape.get_rect()
	var topleft := world.local_to_map(shape_relative + shape_rect.position)
	var bottomright := world.local_to_map(shape_relative + shape_rect.end - Vector2.ONE)
	var result: Array[Vector2i] = []
	for x in range(topleft.x, bottomright.x + 1):
		for y in range(topleft.y, bottomright.y + 1):
			result.append(Vector2i(x, y))
	return result


func get_all_blocking() -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for shape in blocking_shapes:
		result.append_array(shape_to_tiles(shape))
	return result


func can_be_placed(coords: Vector2i) -> bool:
	return not coords in get_all_blocking()
