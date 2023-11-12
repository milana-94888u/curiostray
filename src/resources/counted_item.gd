@tool
class_name CountedItem
extends Resource


@export var item: Item:
	set(value):
		item = value
		emit_changed()
@export var amount := 1:
	set(value):
		amount = value
		if amount == 0:
			item = null
		emit_changed()
