extends GridContainer


@export var available_crafts: Array[CraftingRecipe]:
	get:
		return Globals.player_data.available_crafts
	set(value):
		Globals.player_data.available_crafts = value
		if not is_node_ready():
			await ready
		apply_crafts()


@export var inventory: Inventory


@export var crafting_recipe_slot_scene: PackedScene


func _ready() -> void:
	apply_crafts()


func apply_crafts() -> void:
	for child in get_children():
		remove_child(child)
	for crafting_recipe in available_crafts:
		var child := crafting_recipe_slot_scene.instantiate() as CrafingRecipeSlotUI
		child.recipe = crafting_recipe
		add_child(child)
