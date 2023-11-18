class_name Player
extends CharacterBody2D


var pick_queue: Array[PickableItem]


@onready var left_raycast := $LeftRayCast as RayCast2D
@onready var right_raycast := $RightRayCast as RayCast2D


@onready var ui_canvas := $PlayerUICanvas


@export var player_data: PlayerData:
	get:
		return Globals.player_data
	set(value):
		Globals.player_data = value


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
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	try_picks()


func try_picks() -> void:
	pick_queue = pick_queue.filter(func(pickable_item): return is_instance_valid(pickable_item)) as Array[PickableItem]
	for pickable_item in pick_queue:
		var pick_amount := mini(
			player_data.player_inventory.get_pickable_amount(pickable_item.item),
			pickable_item.amount,
		)
		if pick_amount:
			player_data.player_inventory.pick_item_with_remainder(pickable_item.item, pick_amount)
			pickable_item.amount -= pick_amount
			if pickable_item.amount < 1:
				pickable_item.queue_free()


func _on_player_ui_canvas_set_drill() -> void:
	($UseItemFSM as FiniteStateMachine).transition_to($UseItemFSM/DrillState)


func _on_player_ui_canvas_set_usable_slot(slot: InventorySlot) -> void:
	($UseItemFSM as FiniteStateMachine).transition_to($UseItemFSM/BlockPlaceState, slot)



























