@tool
class_name Item
extends Resource


@export var icon: Texture2D = PlaceholderTexture2D.new()
@export var name := "Item"
@export_range(1, 100, 1, "or_greater") var max_stack := 8


func _init() -> void:
	(icon as PlaceholderTexture2D).size = Vector2(16, 16)
