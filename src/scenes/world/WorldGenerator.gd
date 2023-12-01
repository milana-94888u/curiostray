extends Node


@export var player_spawner: PlayerSpawner


@export var width := 200
@export var depth := 200


@export var world: World
@export var terrain_noise: Noise
@export var caves_noise: Noise
@export var ores_noise: Noise
@export var energy_noise: Noise

@export var main_building_scene: PackedScene
@export var broken_first_communication_tower_scene: PackedScene
@export var broken_second_communication_tower_scene: PackedScene
@export var broken_landing_pad_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not world.is_node_ready():
		await world.ready
	generate_level()
	generate_ores()
	generate_energy()
	set_main_building()
	set_broken_first_communication_tower(50)
	set_broken_second_communication_tower(160)
	set_broken_landing_pad(-80)


func generate_level() -> void:
	for x in range(-width, width):
		var offset := roundi(terrain_noise.get_noise_1d(x) * 5)
		world.set_block(x, offset)
		for y in range(offset + 1, offset + 15):
			world.set_block(x, y)
		for y in range(offset + 15, depth):
			if caves_noise.get_noise_2d(x, y) < 0.3:
				world.set_block(x, y)


func generate_ores() -> void:
	for x in range(-width, width):
		for y in range(15, depth):
			if world.get_cell_atlas_coords(0, Vector2i(x, y)) == Vector2i.ZERO:
				var relative_depth := float(y) / float(depth)
				var spawn_ore := ores_noise.get_noise_2d(x, y) > 0.4
				if not spawn_ore:
					continue
				if relative_depth < 0.33:
					world.set_block(x, y, World.BlockType.COPPER_ORE)
				elif relative_depth < 0.66:
					world.set_block(x, y, World.BlockType.IRON_ORE)
				else:
					world.set_block(x, y, World.BlockType.GOLD_ORE)


func generate_energy() -> void:
	for x in range(-width, width):
		for y in range(depth):
			if world.get_cell_atlas_coords(0, Vector2i(x, y)) == Vector2i.ZERO:
				if energy_noise.get_noise_2d(x, y) < -0.3:
					world.set_block(x, y, World.BlockType.ENERGY_CRYSTAL)


func flatten_area_with_level(begin_x: int, end_x: int) -> int:
	var left_offset := roundi(terrain_noise.get_noise_1d(begin_x) * 5)
	var right_offset := roundi(terrain_noise.get_noise_1d(end_x) * 5)
	var total_level := int(float(left_offset + right_offset) * 0.5) # mean
	for x in range(begin_x, end_x + 1):
		var offset := roundi(terrain_noise.get_noise_1d(x) * 5)
		for y in range(offset, total_level):
			world.erase_cell(0, Vector2(x, y))
		for y in range(total_level + 3, offset + 15):
			world.set_block(x, y)
	for y in range(total_level, total_level + 3):
		var offset := y - total_level
		for x in range(begin_x - offset, end_x + offset + 1):
			world.set_block(x, y, World.BlockType.BRICK)
	return total_level


func set_main_building() -> int:
	var level := flatten_area_with_level(-4, 3)
	player_spawner.init_level = level
	var building := main_building_scene.instantiate() as MainBuilding
	building.player_upgraded.connect(player_spawner.spawn_player)
	building.position = world.map_to_local(Vector2i(0, level - 3)) - 8 * Vector2.ONE
	world.add_child(building)
	return level
	
	
func set_broken_first_communication_tower(x: int) -> void:
	var level := flatten_area_with_level(x - 2, x)
	var building := broken_first_communication_tower_scene.instantiate() as BrokenBuilding
	building.position = world.map_to_local(Vector2i(x, level - 4)) - 8 * Vector2.ONE
	world.add_child(building)
	
	
func set_broken_second_communication_tower(x: int) -> void:
	var level := flatten_area_with_level(x - 3, x + 1)
	var building := broken_second_communication_tower_scene.instantiate() as BrokenBuilding
	building.position = world.map_to_local(Vector2i(x, level - 5)) - 8 * Vector2.ONE
	world.add_child(building)
	
	
func set_broken_landing_pad(x: int) -> void:
	var level := flatten_area_with_level(x - 10, x + 9)
	var building := broken_landing_pad_scene.instantiate() as BrokenBuilding
	building.position = world.map_to_local(Vector2i(x, level - 2))
	world.add_child(building)
	
	
	
	
	
	
