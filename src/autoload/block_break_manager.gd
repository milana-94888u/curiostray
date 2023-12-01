extends Node


#signal continous_breaking_requested(breaking_global_position: Vector2, delta: float)


signal breaking_started
signal breaking_stopped


signal place_block(block: InventorySlot)


signal blocking_body_set(collision_shape: CollisionShape2D)
signal blocking_body_removed(collision_shape: CollisionShape2D)
