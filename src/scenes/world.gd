extends TileMap


@export var item: Item


var is_breaking := false


var breaking_progress_map: Dictionary


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var noise := FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_VALUE_CUBIC
	noise.frequency = 0.15
	noise.fractal_type = FastNoiseLite.FRACTAL_NONE
	for x in range(200):
		var offset := roundi(noise.get_noise_1d(x) * 5)
		print(noise.get_noise_1d(x))
		set_dirt(x, offset)
		for y in range(offset + 1, 200):
			if noise.get_noise_2d(x, y) > 0:
				set_dirt(x, y)
	BlockBreakManager.breaking_started.connect(func(): is_breaking = true)
	BlockBreakManager.breaking_stopped.connect(func(): is_breaking = false)


func set_dirt(x: int, y: int) -> void:
	set_cell(0, Vector2i(x, y), 0, Vector2i.ONE)


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
		var coords := local_to_map(get_local_mouse_position())
		if get_cell_atlas_coords(0, coords) != Vector2i.ONE:
			clean_breaking_mapping()
			return
		if coords in breaking_progress_map:
			breaking_progress_map[coords] += 2 * delta
		else:
			breaking_progress_map[coords] = delta
		if breaking_progress_map[coords] >= 0.5:
			set_cell(0, coords)
			breaking_progress_map.erase(coords)
	clean_breaking_mapping()
