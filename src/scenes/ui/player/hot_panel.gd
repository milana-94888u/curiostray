extends HBoxContainer


signal set_usable_slot(slot: InventorySlot)
signal set_drill


var button_group := ButtonGroup.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for slot in get_children():
		slot = slot as Button
		slot.button_group = button_group
		if slot is Slot:
			slot.pressed.connect(select_slot.bind(slot))
		else:
			slot.button_pressed = true
			slot.pressed.connect(select_drill_slot)


func select_slot(slot: Slot) -> void:
	set_usable_slot.emit(slot.inventory_slot)


func select_drill_slot() -> void:
	set_drill.emit()


func set_inventory(inventory: Inventory) -> void:
	for i in 5:
		get_child(i).inventory_slot = inventory.slots[i]
