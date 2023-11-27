class_name PlayerSpawner
extends Node


@export var world: World


var init_level: int


@export var player_levels: Array[PackedScene]


var player: Player


func spawn_player(player_level: int) -> void:
	if is_instance_valid(player):
		player.queue_free()
	player = player_levels[player_level - 1].instantiate() as Player
	player.position = world.map_to_local(Vector2i(0, init_level)) - Vector2(0, 6 + 6 * player_level)
	world.add_child(player)
