extends PanelContainer


@export var inventory_slot: InventorySlot:
	set = apply_slot


func apply_slot(new_slot: InventorySlot) -> void:
	inventory_slot = new_slot
	if not is_node_ready():
		await ready
	if not is_instance_valid(inventory_slot):
		$TextureRect.texture = null
		return
	if is_instance_valid(inventory_slot.item):
		$TextureRect.texture = inventory_slot.item.icon
	if not inventory_slot.changed.is_connected(apply_slot):
		inventory_slot.changed.connect(apply_slot.bind(inventory_slot))
