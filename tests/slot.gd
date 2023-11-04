extends PanelContainer


@export var texture: Texture2D:
	get:
		return $TextureRect.texture
	set(value):
		$TextureRect.texture = value


func _gui_input(event: InputEvent) -> void:
	if event.is_action_released("lmb"):
		if is_instance_valid($TextureRect.texture):
			force_drag($TextureRect.texture, $TextureRect.duplicate())
			$TextureRect.texture = null

func _make_custom_tooltip(_for_text: String) -> Object:
	return $TextureRect.duplicate()
#func _get_drag_data(_at_position: Vector2) -> Variant:
#	if is_instance_valid($TextureRect.texture):
#		set_drag_preview($TextureRect.duplicate())
#		var return_data := $TextureRect.texture as Texture2D
#		$TextureRect.texture = null
#		return return_data
#	return null


func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
	return not is_instance_valid($TextureRect.texture)


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	$TextureRect.texture = data as Texture2D
