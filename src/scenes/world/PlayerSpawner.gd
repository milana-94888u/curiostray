class_name PlayerSpawner
extends Node


@export var world: World


var init_level: int


@export var player_levels: Array[PackedScene]


var player: Player


func spawn_player(player_level: int) -> void:
	$CanvasLayer/NewLevelLabel.text = "Player level level %d" % player_level
	var tween := get_tree().create_tween().bind_node(self)
	tween.tween_property($CanvasLayer/NewLevelLabel, "modulate:a", 1.0, 0.5)
	tween.tween_property($CanvasLayer/NewLevelLabel, "modulate:a", 0.0, 0.5)
	if is_instance_valid(player):
		player.queue_free()
	player = player_levels[player_level - 1].instantiate() as Player
	player.position = world.map_to_local(Vector2i(0, init_level)) - Vector2(0, 6 + 6 * player_level)
	world.add_child(player)
	if not player.player_data.no_energy.is_connected(respawn_player):
		player.player_data.no_energy.connect(respawn_player.bind(player_level))


func respawn_player(player_level: int) -> void:
	Globals.player_data.energy = Globals.player_data.max_energy
	for slot in Globals.player_data.player_inventory.slots:
		slot.empty()
	player.queue_free()
	spawn_player(player_level)
