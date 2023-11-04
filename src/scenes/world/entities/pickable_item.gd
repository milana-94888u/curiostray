@tool
class_name PickableItem
extends Area2D


@export var item: Item:
	set(new_item):
		if not is_node_ready():
			await ready
		item = new_item
		if not is_instance_valid(item):
			$CollisionShape2D.disabled = true
			$Sprite2D.texture = null
			return
		$CollisionShape2D.disabled = false
		$Sprite2D.texture = item.icon
		


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
