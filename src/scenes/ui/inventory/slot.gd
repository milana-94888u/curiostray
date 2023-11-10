class_name Slot
extends Button


signal change_with_floating_requested(from: InventorySlot)
signal pick_one_requested(from: InventorySlot)


@export var inventory_slot: InventorySlot:
	set = apply_slot


func apply_slot(new_slot: InventorySlot) -> void:
	inventory_slot = new_slot
	if not is_node_ready():
		await ready
	if not is_instance_valid(inventory_slot):
		$TextureRect.texture = null
		$Label.hide()
		return
	if is_instance_valid(inventory_slot.item):
		$TextureRect.texture = inventory_slot.item.icon
		$Label.show()
		$Label.text = str(inventory_slot.amount)
	else:
		$TextureRect.texture = null
		$Label.hide()
	if not inventory_slot.changed.is_connected(apply_slot):
		inventory_slot.changed.connect(apply_slot.bind(inventory_slot))


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				change_with_floating_requested.emit(inventory_slot)
			elif event.button_index == MOUSE_BUTTON_RIGHT:
				pick_one_requested.emit(inventory_slot)
