@tool
class_name Item
extends Resource


@export var icon: Texture2D = PlaceholderTexture2D.new()
@export var name := "Item"
@export var categories: Array[ItemCategory] = []
@export_range(1, 100, 1, "or_greater") var max_stack := 8
