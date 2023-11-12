class_name CrafingRecipeSlotUI
extends Button


@export var recipe: CraftingRecipe:
	set = apply_recipe
@export var is_available := false:
	set(value):
		is_available = value
		if is_available:
			modulate = Color.WHITE
		else:
			modulate = Color(Color.WHITE, 0.5)
		disabled = not is_available


@onready var result_display := $ResultDisplay as CountedItemUI


@export var counted_item_scene: PackedScene


func apply_recipe(new_recipe: CraftingRecipe) -> void:
	recipe = new_recipe
	tooltip_text = ""
	if not is_node_ready():
		await ready
	if not is_instance_valid(recipe):
		return
	result_display.counted_item = recipe.result
	tooltip_text = recipe.result.item.name


func _make_custom_tooltip(_for_text: String) -> Object:
	if not is_instance_valid(recipe):
		return null
	var result := HBoxContainer.new()
	for ingridient in recipe.ingridients:
		var ingridient_slot := counted_item_scene.instantiate() as CountedItemUI
		ingridient_slot.counted_item = ingridient.reqiured_item
		result.add_child(ingridient_slot)
	return result


func _on_pressed() -> void:
	print("pressed")
