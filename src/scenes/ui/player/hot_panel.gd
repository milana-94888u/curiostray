extends HBoxContainer


signal set_usable_slot(slot: InventorySlot)
signal set_drill


var button_group := ButtonGroup.new()


func get_shortcut(index: int) -> Shortcut:
	var shortcut = Shortcut.new()
	var input_event := InputEventAction.new()
	input_event.action = "slot%d" % (index + 1)
	shortcut.events.append(input_event)
	return shortcut


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for slot_index in len(get_children()):
		var slot := get_child(slot_index) as Button
		slot.toggle_mode = true
		slot.button_group = button_group
		slot.shortcut = get_shortcut(slot_index)
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
