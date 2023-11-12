@tool
class_name Inventory
extends Resource


@export var slots: Array[InventorySlot]:
	set(new_slots):
		print("applying slots")
		slots = new_slots
		for slot in slots:
			if not slot.changed.is_connected(emit_changed):
				slot.changed.connect(emit_changed)


func _init() -> void:
	for i in 20:
		slots.append(InventorySlot.new())


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


func has_enough(counted_item: CountedItem) -> bool:
	var total_amount := slots.filter(
		func(slot: InventorySlot): return slot.item == counted_item.item
	).reduce(
		func(accum: int, slot: InventorySlot): return accum + slot.amount,
		0,
	) as int
	return total_amount >= counted_item.amount


func collect_item(counted_item: CountedItem) -> void:
	var collected_amount := 0
	for slot in slots.filter(
		func(slot: InventorySlot): return slot.item == counted_item.item
	) as Array[InventorySlot]:
		if collected_amount < counted_item.amount:
			var taken_amount = min(slot.amount, counted_item.amount - collected_amount)
			collected_amount += taken_amount
			slot.amount -= taken_amount
		if collected_amount >= counted_item.amount:
			return


func craft(recipe: CraftingRecipe) -> CountedItem:
	if not can_be_crafted(recipe):
		return null
	for ingdirient in recipe.ingridients:
		collect_item(ingdirient.reqiured_item)
	return recipe.result


func can_be_crafted(recipe: CraftingRecipe) -> bool:
	return recipe.ingridients.all(
		func(ingridient: CrafringIngridient):
			return has_enough(ingridient.reqiured_item)
	)
