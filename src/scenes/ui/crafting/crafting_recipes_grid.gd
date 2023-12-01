extends GridContainer


signal craft_requested(recipe: CraftingRecipe)


@export var available_crafts: Array[CraftingRecipe]:
	get:
		return Globals.player_data.available_crafts
	set(value):
		Globals.player_data.available_crafts = value
		if not is_node_ready():
			await ready
		apply_crafts()


@export var inventory: Inventory:
	get:
		return Globals.player_data.player_inventory
	set(new_inventory):
		Globals.player_data.player_inventory = new_inventory


@export var crafting_recipe_slot_scene: PackedScene


func _ready() -> void:
	if is_instance_valid(inventory):
		apply_crafts()
		if not inventory.changed.is_connected(apply_crafts):
			inventory.changed.connect(apply_crafts)


func apply_crafts() -> void:
	for child in get_children():
		remove_child(child)
	for crafting_recipe in available_crafts:
		var child := crafting_recipe_slot_scene.instantiate() as CrafingRecipeSlotUI
		child.recipe = crafting_recipe
		child.is_available = inventory.can_be_crafted(crafting_recipe)
		child.pressed.connect(func(): craft_requested.emit(crafting_recipe))
		add_child(child)


func _on_visibility_changed() -> void:
	apply_crafts()
