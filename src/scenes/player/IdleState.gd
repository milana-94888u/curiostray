extends State


@export var player: Player


signal fall_started
signal movement_started(x_direction: float)
signal fly_started


func enter(_message: Variant = null) -> void:
	Sounds.stop_moving()
	player.velocity = Vector2.ZERO


func exit() -> void:
	player.left_engine.hide()
	player.right_engine.hide()


func physics_update(_delta: float) -> void:
	player.left_engine.hide()
	player.right_engine.hide()
	if not player.is_on_floor():
		fall_started.emit()
		return
	if player.left_shapecast.is_colliding() and not player.right_shapecast.is_colliding():
		Sounds.start_moving()
		player.right_engine.show()
		player.left_engine.hide()
		player.player_data.energy -= 1
	elif player.right_shapecast.is_colliding() and not player.left_shapecast.is_colliding():
		Sounds.start_moving()
		player.left_engine.show()
		player.right_engine.hide()
		player.player_data.energy -= 1
	else:
		Sounds.stop_moving()
	var move_direction := Input.get_axis("left", "right")
	if not is_zero_approx(move_direction):
		movement_started.emit(move_direction)
	if Input.is_action_pressed("fly"):
		fly_started.emit()
	player.move_and_slide()
