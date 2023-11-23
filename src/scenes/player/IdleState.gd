extends State


@export var player: Player


signal fall_started
signal movement_started(x_direction: float)
signal fly_started


func enter(_message: Variant = null) -> void:
	player.velocity = Vector2.ZERO


func exit() -> void:
	player.left_engine.hide()
	player.right_engine.hide()


func physics_update(_delta: float) -> void:
	if not player.is_on_floor():
		fall_started.emit()
		return
	if player.left_raycast.is_colliding() and not player.right_raycast.is_colliding():
		player.right_engine.show()
		player.left_engine.hide()
		player.player_data.energy -= 1
	elif player.right_raycast.is_colliding() and not player.left_raycast.is_colliding():
		player.left_engine.show()
		player.right_engine.hide()
		player.player_data.energy -= 1
	var move_direction := Input.get_axis("left", "right")
	if not is_zero_approx(move_direction):
		movement_started.emit(move_direction)
	if Input.is_action_pressed("fly"):
		fly_started.emit()
	player.move_and_slide()
