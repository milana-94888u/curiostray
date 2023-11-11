class_name InventoryUI
extends GridContainer


signal change_with_floating_requested(from: InventorySlot)
signal pick_one_requested(from: InventorySlot)


@export var inventory: Inventory:
	get:
		return Globals.player_data.player_inventory
	set(new_inventory):
		Globals.player_data.player_inventory = new_inventory
		if is_instance_valid(inventory):
			apply_inventory()


func _ready() -> void:
	if is_instance_valid(inventory):
		apply_inventory()


func apply_inventory() -> void:
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
