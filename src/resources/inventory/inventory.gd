class_name Inventory
extends Resource


@export var slots: Array[InventorySlot]


func get_pickable_amount(item: Item) -> int:
	var accumulator := 0
	for slot in slots:
		if slot.item == item or slot.is_empty():
			accumulator += item.max_stack - slot.amount
	return accumulator


func pick_item_with_remainder(item: Item, amount := 1) -> int:
	for slot in slots:
		if amount <= 0:
			break
		if slot.item == item or slot.is_empty():
			var change := mini(item.max_stack - slot.amount, amount)
			amount -= change
			slot.set_item(item, slot.amount + change)
	return amount
