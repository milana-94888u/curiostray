extends Node


@export var world: World


var blocking_shapes: Array[CollisionShape2D]


func _ready() -> void:
	BlockBreakManager.blocking_body_set.connect(shape_to_tiles)


func shape_to_tiles(shape: CollisionShape2D) -> void:
	var shape_relative := world.to_local(shape.global_position)
	var shape_rect := shape.shape.get_rect()
	var topleft := world.local_to_map(shape_relative + shape_rect.position)
	var bottomright := world.local_to_map(shape_relative + shape_rect.end - Vector2.ONE)
#	for x in range(topleft.x, bottomright.x + 1):
#		for y in range(topleft.y, bottomright.y + 1):
#			world.set_block(x, y, world.BlockType.GOLD)
