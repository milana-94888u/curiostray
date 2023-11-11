extends CanvasLayer


signal set_usable_slot(slot: InventorySlot)
signal set_drill


@onready var hot_panel := $HotPanel as HotPanel
@onready var entire_inventory_ui := $EntireInventoryUI as EntireInventoryUI


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


func _ready() -> void:
	hot_panel.set_drill.connect(func(): set_drill.emit())
	hot_panel.set_usable_slot.connect(
		func(slot: InventorySlot): set_usable_slot.emit(slot)
	)
