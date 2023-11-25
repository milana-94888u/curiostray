class_name UpgradeAsk
extends Control


signal upgraded


@onready var items_container := $VBoxContainer/HBoxContainer as HBoxContainer
@onready var upgrade_button := $VBoxContainer/UpgradeButton as Button

@export var recipe: Array[CrafringIngridient]:
	set(value):
		recipe = value
		if not is_node_ready():
			await ready
		apply_recipe()


@export var inventory: Inventory:
	get:
		return Globals.player_data.player_inventory
	set(new_inventory):
		if not is_node_ready():
			await ready
		Globals.player_data.player_inventory = new_inventory


@export var crafting_recipe_slot_scene: PackedScene


func _ready() -> void:
	apply_recipe()


func apply_recipe() -> void:
	for child in items_container.get_children():
		items_container.remove_child(child)
	if not is_instance_valid(inventory):
		return
	if not inventory.changed.is_connected(apply_recipe):
		inventory.changed.connect(apply_recipe)
	var can_be_repaired := true
	for ingridient in recipe:
		var ingridient_display := crafting_recipe_slot_scene.instantiate() as CountedItemUI
		ingridient_display.counted_item = ingridient.reqiured_item
		if not inventory.has_enough(ingridient.reqiured_item):
			can_be_repaired = false
			ingridient_display.modulate.a = 0.5
		items_container.add_child(ingridient_display)
	upgrade_button.disabled = not can_be_repaired


func _on_upgrade_button_pressed() -> void:
	inventory.consume_ingridients(recipe)
	upgraded.emit()
