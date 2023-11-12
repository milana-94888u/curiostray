class_name FloatingSlot
extends PanelContainer


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


func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()


func _on_slot_display_visibility_changed() -> void:
	visible = slot_display.visible
