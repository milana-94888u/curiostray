class_name EntireInventoryUI
extends Control


@onready var inventory_ui := %InventoryUI as InventoryUI
@onready var floating_slot := %FloatingSlot as FloatingSlot


func _ready() -> void:
	inventory_ui.change_with_floating_requested.connect(try_change_with_floating)
	inventory_ui.pick_one_requested.connect(try_pick_one_to_floating)


func try_change_with_floating(from: InventorySlot) -> void:
	from.try_change_from(floating_slot.inventory_slot)


func try_pick_one_to_floating(from: InventorySlot) -> void:
	floating_slot.inventory_slot.try_pick_one_from(from)


func _on_crafting_recipes_grid_craft_requested(recipe: CraftingRecipe) -> void:
	print("crafting request")
	if is_instance_valid(floating_slot.inventory_slot.item):
		return
	var craft_result := inventory_ui.inventory.craft(recipe)
	if craft_result:
		floating_slot.inventory_slot.counted_item = craft_result
