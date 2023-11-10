class_name InventorySlot
extends Resource


@export var item: Item
@export var amount := 0:
	set(value):
		amount = value
		emit_changed()


func is_empty() -> bool:
	return amount == 0


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
