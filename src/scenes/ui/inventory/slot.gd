class_name Slot
extends Button


signal change_with_floating_requested(from: InventorySlot)
signal pick_one_requested(from: InventorySlot)


@export var inventory_slot: InventorySlot:
	set = apply_slot


@onready var slot_display := $SlotDisplay as CountedItemUI


func apply_slot(new_slot: InventorySlot) -> void:
	inventory_slot = new_slot
	if not is_node_ready():
		await ready
	if not is_instance_valid(inventory_slot):
		return
	slot_display.counted_item = inventory_slot.counted_item


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				change_with_floating_requested.emit(inventory_slot)
			elif event.button_index == MOUSE_BUTTON_RIGHT:
				pick_one_requested.emit(inventory_slot)
