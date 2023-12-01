class_name BuildBlocker
extends Node


func _ready() -> void:
	var collision_shape := get_parent() as CollisionShape2D
	if not collision_shape.is_node_ready():
		await collision_shape.ready
	BlockBreakManager.blocking_body_set.emit(collision_shape)
	collision_shape.tree_exiting.connect(func(): BlockBreakManager.blocking_body_removed.emit(collision_shape))
