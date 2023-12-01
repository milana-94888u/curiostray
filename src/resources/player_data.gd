class_name PlayerData
extends Resource


signal no_energy


@export var available_crafts: Array[CraftingRecipe]
@export var player_inventory: Inventory


@export var max_energy := 2000
@export var energy := 2000:
	set(value):
		if value > max_energy:
			return
		energy = value
		if energy <= 0:
			energy = 0
			no_energy.emit()
