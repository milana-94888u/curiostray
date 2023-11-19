extends State


@export var player: Player


signal fall_started
signal stopped
signal fly_started


func enter(message = null) -> void:
	player.velocity = Vector2(message as float, 0) * player.move_speed


func physics_update(_delta: float) -> void:
	if not player.is_on_floor():
		fall_started.emit()
		return
	if Input.is_action_pressed("fly"):
		fly_started.emit()
		
	player.velocity.x = Input.get_axis("left", "right") * player.move_speed
	if player.velocity.is_zero_approx():
		stopped.emit()
	player.move_and_slide()
