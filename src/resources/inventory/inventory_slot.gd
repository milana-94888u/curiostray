class_name InventorySlot
extends Resource


var counted_item: CountedItem = CountedItem.new()

@export var item: Item:
	get:
		return counted_item.item
	set(value):
		counted_item.item = value
@export var amount := 0:
	get:
		return counted_item.amount
	set(value):
		counted_item.amount = value

@export var accepted_category: ItemCategory


func is_empty() -> bool:
	return amount == 0


func can_put_item(asked_item: Item) -> bool:
	if not is_instance_valid(asked_item):
		return true
	if not is_instance_valid(accepted_category):
		return true
	return accepted_category in asked_item.categories


func try_change_from(from: InventorySlot) -> void:
	if is_empty() and from.is_empty():
		return
	if not (can_put_item(from.item) and from.can_put_item(item)):
		return
	if item == from.item:
		var remaining_amount := item.max_stack - amount
		if remaining_amount >= from.amount:
			amount += from.amount
			from.empty()
		else:
			amount += remaining_amount
			from.amount -= remaining_amount
		return
	var temp_item := from.item
	var temp_amount := from.amount
	from.set_item(item, amount)
	set_item(temp_item, temp_amount)


func try_pick_one_from(from: InventorySlot) -> void:
	if not can_put_item(from.item):
		return
	if not is_empty():
		if item != from.item:
			return
	if amount >= from.item.max_stack:
		return
	set_item(from.take_one(), amount + 1)


func take_one() -> Item:
	if is_empty():
		return null
	set_block_signals(true)
	var result := item
	amount -= 1
	if amount == 0:
		item = null
	set_block_signals(false)
	emit_changed()
	return result


func empty() -> void:
	set_block_signals(true)
	item = null
	amount = 0
	set_block_signals(false)
	emit_changed()


func set_item(received_item: Item, received_amount := 1) -> void:
	set_block_signals(true)
	item = received_item
	amount = received_amount
	set_block_signals(false)
	emit_changed()
