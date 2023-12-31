@tool
class_name PickableItem
extends CharacterBody2D


var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")


@export var item: Item:
	set(new_item):
		item = new_item
		if not is_node_ready():
			await ready
		if not is_instance_valid(item):
			$CollisionShape2D.disabled = true
			$Sprite2D.texture = null
			return
		$CollisionShape2D.disabled = false
		$Sprite2D.texture = item.icon
@export var amount := 1


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	velocity.y += gravity * delta
	move_and_slide()


func _on_pickable_area_body_entered(body: Node2D) -> void:
	if body is Player:
		body.enqueue_pick_item(self)


func _on_pickable_area_body_exited(body: Node2D) -> void:
	if body is Player:
		body.dequeue_pick_item(self)


func _on_merge_area_body_entered(body: Node2D) -> void:
	if body is PickableItem:
		pass
