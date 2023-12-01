class_name Player
extends CharacterBody2D


var pick_queue: Array[PickableItem]


@export var move_speed := 300.0
@export var fly_time := 3.0
@export var breaking_boost := 1.0


@export var blocks: Array[Item]


@onready var left_shapecast := $LeftShapeCast as ShapeCast2D
@onready var right_shapecast := $RightShapeCast as ShapeCast2D


@onready var left_engine := $LeftPlayerEngineFire as Sprite2D
@onready var right_engine := $RightPlayerEngineFire as Sprite2D


@onready var ui_canvas := $PlayerUICanvas


@onready var use_item_fsm := $UseItemFSM as FiniteStateMachine
@onready var block_place_state := $UseItemFSM/BlockPlaceState as State
@onready var drill_state := $UseItemFSM/DrillState as State
@onready var use_item_state := $UseItemFSM/UseItemState as State


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
	use_item_fsm.transition_to(drill_state)


func _on_player_ui_canvas_set_usable_slot(slot: InventorySlot) -> void:
	if slot.item in blocks:
		use_item_fsm.transition_to(block_place_state, slot)
	else:
		use_item_fsm.transition_to(use_item_state, slot)





























