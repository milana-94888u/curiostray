class_name Player
extends CharacterBody2D


var pick_queue: Array[PickableItem]


@export var inventory: Inventory:
	set(new_inventory):
		inventory = new_inventory
		if not is_node_ready():
			await ready
		if not is_instance_valid(inventory):
			return
		if not inventory.changed.is_connected(change_inventory):
			inventory.changed.connect(change_inventory)
		$CanvasLayer/HotPanel.set_inventory(inventory)


func change_inventory() -> void:
	inventory = inventory


func enqueue_pick_item(pickable_item: PickableItem) -> void:
	pick_queue.push_back(pickable_item)


func dequeue_pick_item(pickable_item: PickableItem) -> void:
	pick_queue.erase(pickable_item)


@export var interactive_range := 64.0
@onready var drill_ray := $DrillRay as DrillRay


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta: float) -> void:
	var drill_direction := get_local_mouse_position()
	if drill_direction.length() < interactive_range:
		drill_ray.show_ray_to_point(drill_direction)
	else:
		drill_ray.hide()
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	try_picks()
	
#	if pick_queue:
#		var pick_amount := mini(
#			inventory.get_pickable_amount(pick_queue[0].item),
#			pick_queue[0].amount,
#		)
#		if pick_amount:
#			pick_queue[0].amount -= pick_amount
#			if pick_queue[0].amount < 1:
#				pick_queue.pop_at(0)
#				pick_queue.remove_at(0)
#		var pickable_item := pick_queue.pop_front() as PickableItem
#		pickable_item.queue_free()



func try_picks() -> void:
	pick_queue = pick_queue.filter(func(pickable_item): return is_instance_valid(pickable_item)) as Array[PickableItem]
	for pickable_item in pick_queue:
		var pick_amount := mini(
			inventory.get_pickable_amount(pickable_item.item),
			pickable_item.amount,
		)
		if pick_amount:
			inventory.pick_item_with_remainder(pickable_item.item, pick_amount)
			pickable_item.amount -= pick_amount
			if pickable_item.amount < 1:
				pickable_item.queue_free()



















