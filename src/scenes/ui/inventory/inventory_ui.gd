class_name InventoryUI
extends GridContainer


@export var inventory: Inventory:
	set = apply_inventory


func apply_inventory(new_inventory: Inventory) -> void:
	inventory = new_inventory
	if not is_node_ready():
		await ready
	for i in 20:
		var slot := get_child(i) as Slot
		slot.inventory_slot = inventory.slots[i]
