extends Node


@export var width := 200
@export var depth := 200


@export var world: World
@export var terrain_noise: Noise
@export var caves_noise: Noise
@export var ores_noise: Noise


@export var main_building_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not world.is_node_ready():
		await world.ready
	generate_level()
	generate_mineable()
	set_main_building()


func generate_level():
	for x in range(-width, width):
		var offset := roundi(terrain_noise.get_noise_1d(x) * 5)
		world.set_block(x, offset)
		for y in range(offset + 1, offset + 15):
			world.set_block(x, y)
		for y in range(offset + 15, depth):
			if caves_noise.get_noise_2d(x, y) < 0.3:
				world.set_block(x, y)


func generate_mineable():
	for x in range(-width, width):
		for y in range(depth):
			if world.get_cell_atlas_coords(0, Vector2i(x, y)) == Vector2i.ZERO:
				var relative_depth := float(y) / float(depth)
				var cell_value := (ores_noise.get_noise_2d(x, y)) * relative_depth
				world.set_block(x, y, floori(cell_value * 6.0))


func flatten_area_with_level(begin_x: int, end_x: int) -> int:
	var left_offset := roundi(terrain_noise.get_noise_1d(begin_x) * 5)
	var right_offset := roundi(terrain_noise.get_noise_1d(end_x) * 5)
	var total_level := int(float(left_offset + right_offset) * 0.5) # mean
	for x in range(begin_x, end_x + 1):
		var offset := roundi(terrain_noise.get_noise_1d(x) * 5)
		for y in range(offset, total_level):
			world.erase_cell(0, Vector2(x, y))
		for y in range(total_level, offset + 15):
			world.set_block(x, y)
	return total_level


func set_main_building() -> void:
	var building := main_building_scene.instantiate() as Area2D
	var level := flatten_area_with_level(-4, 3)
	building.position = world.map_to_local(Vector2i(0, level - 3)) - 8 * Vector2.ONE
	world.add_child(building)
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
