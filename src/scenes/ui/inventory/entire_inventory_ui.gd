class_name EntireInventoryUI
extends Control


@onready var inventory_ui := %InventoryUI as InventoryUI


@export var inventory: Inventory:
	set(value):
		inventory = value
		if not is_node_ready():
			await ready
		inventory_ui.inventory = inventory
