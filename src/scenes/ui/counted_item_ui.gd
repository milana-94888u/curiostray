@tool
class_name CountedItemUI
extends TextureRect


@export var counted_item: CountedItem:
	set = apply_counted_item


@onready var amount_label := $Label as Label


func apply_counted_item(new_counted_item: CountedItem) -> void:
	counted_item = new_counted_item
	if not is_node_ready():
		await ready
	if not is_instance_valid(counted_item):
		hide()
		return
	if not counted_item.changed.is_connected(apply_counted_item):
		counted_item.changed.connect(apply_counted_item.bind(counted_item))
	if not is_instance_valid(counted_item.item):
		hide()
		return
	show()
	texture = counted_item.item.icon
	if counted_item.amount > 1:
		amount_label.text = str(counted_item.amount)
		amount_label.show()
	else:
		amount_label.hide()
