class_name Slot
extends Button


signal change_with_floating_requested(from: InventorySlot)
signal pick_one_requested(from: InventorySlot)


@export var inventory_slot: InventorySlot:
	set = apply_slot


@onready var slot_display := $SlotDisplay as CountedItemUI


func apply_slot(new_slot: InventorySlot) -> void:
	inventory_slot = new_slot
	tooltip_text = ""
	if not is_node_ready():
		await ready
	if not is_instance_valid(inventory_slot):
		return
	if not inventory_slot.changed.is_connected(apply_slot):
		inventory_slot.changed.connect(apply_slot.bind(inventory_slot))
	slot_display.counted_item = inventory_slot.counted_item
	if is_instance_valid(inventory_slot.item):
		tooltip_text = "present"


func _make_custom_tooltip(_for_text: String) -> Object:
	if not is_instance_valid(inventory_slot):
		return null
	if not is_instance_valid(inventory_slot.item):
		return null
	var result := Label.new()
	result.text = "%s (%d)" % [inventory_slot.item.name, inventory_slot.amount]
	return result


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				change_with_floating_requested.emit(inventory_slot)
			elif event.button_index == MOUSE_BUTTON_RIGHT:
				pick_one_requested.emit(inventory_slot)
