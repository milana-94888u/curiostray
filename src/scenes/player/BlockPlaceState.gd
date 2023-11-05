extends State


@export var player: Player
var inventory_slot: InventorySlot


func enter(message: Variant = null) -> void:
	if message is InventorySlot:
		inventory_slot = message


func process_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			if player.get_local_mouse_position().length() < player.interactive_range:
				if inventory_slot.amount > 0:
					inventory_slot.amount -= 1
					if inventory_slot.amount == 0:
						inventory_slot.empty()
					BlockBreakManager.place_block.emit()
