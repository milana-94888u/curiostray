extends State


@export var player: Player


var remaining_fly_time: float


signal fall_started


func enter(_message = null) -> void:
	remaining_fly_time = player.fly_time
	player.velocity = Vector2.ZERO
	player.left_engine.show()
	player.right_engine.show()


func exit() -> void:
	player.left_engine.hide()
	player.right_engine.hide()


func physics_update(delta: float) -> void:
	if Input.is_action_pressed("fly") and remaining_fly_time > 0:
		player.velocity.x = Input.get_axis("left", "right") * player.move_speed
		player.velocity.y = -player.move_speed
	else:
		fall_started.emit()
	remaining_fly_time -= delta
	player.move_and_slide()
