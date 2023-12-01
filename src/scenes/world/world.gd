class_name World
extends TileMap


enum BlockType {
	SILLICAT_MINERAL,
	COPPER_ORE,
	IRON_ORE,
	GOLD_ORE,
	ENERGY_CRYSTAL,
	BRICK,
}


var is_breaking := false


var breaking_progress_map: Dictionary


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BlockBreakManager.breaking_started.connect(func(): is_breaking = true)
	BlockBreakManager.breaking_stopped.connect(func(): is_breaking = false)
	BlockBreakManager.place_block.connect(place_block_by_click)


func set_block(x: int, y: int, block := BlockType.SILLICAT_MINERAL) -> void:
	set_cell(0, Vector2i(x, y), 0, Vector2i(block, 0))


func can_be_placed(coords: Vector2i) -> bool:
	return get_cell_source_id(0, coords) == -1 and $BuildBlockingBodiesManager.can_be_placed(coords)


func place_block_by_click(block_slot: InventorySlot) -> void:
	var coords := local_to_map(get_local_mouse_position())
	if not can_be_placed(coords):
		return
	var block := block_slot.take_one()
	var source := tile_set.get_source(0) as TileSetAtlasSource
	var size := source.get_atlas_grid_size()
	for x in size.x:
		for y in size.y:
			var atlas_coords := Vector2i(x, y)
			if source.has_tile(atlas_coords):
				if source.get_tile_data(atlas_coords, 0).get_custom_data("drop") == block:
					set_cell(0, coords, 0, atlas_coords)
					Sounds.place_block()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Camera2D.position += Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * delta * 1000


func clean_breaking_mapping() -> void:
	for coords in breaking_progress_map:
		if breaking_progress_map[coords] <= 0.0:
			breaking_progress_map.erase(coords)


func _physics_process(delta: float) -> void:
	for coords in breaking_progress_map:
		breaking_progress_map[coords] -= delta
	if is_breaking:
		Sounds.start_digging()
		var coords := local_to_map(get_local_mouse_position())
		if get_cell_atlas_coords(0, coords) == Vector2i(-1, -1):
			clean_breaking_mapping()
			return
		var break_time := get_cell_tile_data(0, coords).get_custom_data("break_time") as float
		if break_time <= 0.0:
			clean_breaking_mapping()
			return
		if coords in breaking_progress_map:
			breaking_progress_map[coords] += 2 * delta * $PlayerSpawner.player.breaking_boost
		else:
			breaking_progress_map[coords] = delta * $PlayerSpawner.player.breaking_boost
		if breaking_progress_map[coords] >= break_time:
			var dropped_item := preload("res://src/scenes/world/entities/pickable_item.tscn").instantiate()
			dropped_item.position = map_to_local(coords)
			dropped_item.item = get_cell_tile_data(0, coords).get_custom_data("drop")
			erase_cell(0, coords)
			add_child(dropped_item)
			breaking_progress_map.erase(coords)
	else:
		Sounds.stop_digging()
	clean_breaking_mapping()
