extends State


@export var player: Player


var gravity := ProjectSettings.get_setting("physics/2d/default_gravity") as int


signal landed


func enter(_message: Variant = null) -> void:
	player.velocity.y = gravity


func physics_update(_delta: float) -> void:
	if player.is_on_floor():
		landed.emit()
		return
	player.velocity.x = Input.get_axis("left", "right") * player.move_speed
	player.move_and_slide()

