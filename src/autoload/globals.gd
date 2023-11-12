extends Node


@export var player_data: PlayerData = PlayerData.new()


func _ready() -> void:
	player_data = load("res://resources/player_data.tres")
