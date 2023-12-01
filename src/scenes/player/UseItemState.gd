extends State


@export var player: Player
var inventory_slot: InventorySlot


func enter(message: Variant = null) -> void:
	if message is InventorySlot:
		inventory_slot = message



func process_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			if inventory_slot.item == preload("res://resources/inventory/items/energy_crystal.tres"):
				player.player_data.energy += 200
				inventory_slot.take_one()
