class_name Building
extends Area2D

@export var unlocked_recipe: CraftingRecipe


func _ready() -> void:
	if is_instance_valid(unlocked_recipe):
		Globals.player_data.available_crafts.append(unlocked_recipe)
