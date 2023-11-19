class_name Player
extends CharacterBody2D


var pick_queue: Array[PickableItem]


@export var move_speed := 300.0
@export var fly_time := 10.0


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


func _physics_process(_delta: float) -> void:
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





























