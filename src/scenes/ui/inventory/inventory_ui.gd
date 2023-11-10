class_name InventoryUI
extends GridContainer


signal change_with_floating_requested(from: InventorySlot)
signal pick_one_requested(from: InventorySlot)


@export var inventory: Inventory:
	set = apply_inventory


func apply_inventory(new_inventory: Inventory) -> void:
	inventory = new_inventory
	if not is_node_ready():
		await ready
	for i in 20:
		var slot := get_child(i) as Slot
		slot.inventory_slot = inventory.slots[i]
		slot.change_with_floating_requested.connect(
			func(from: InventorySlot):
				change_with_floating_requested.emit(from)
		)
		slot.pick_one_requested.connect(
			func(from: InventorySlot):
				pick_one_requested.emit(from)
		)
