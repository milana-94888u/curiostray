extends CanvasLayer


@onready var hot_panel := $HotPanel as HotPanel
@onready var entire_inventory_ui := $EntireInventoryUI as EntireInventoryUI


@export var inventory: Inventory:
	set(new_inventory):
		inventory = new_inventory
		if not is_node_ready():
			await ready
		hot_panel.inventory = new_inventory
		entire_inventory_ui.inventory = new_inventory


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if entire_inventory_ui.visible:
			entire_inventory_ui.hide()
			get_tree().paused = false
			hot_panel.show()
		else:
			hot_panel.hide()
			get_tree().paused = true
			entire_inventory_ui.show()
