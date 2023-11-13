extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BlockBreakManager.blocking_body_set.emit($CollisionShape2D)
