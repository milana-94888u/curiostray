extends TextureProgressBar


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	max_value = Globals.player_data.max_energy
	value =  Globals.player_data.energy
