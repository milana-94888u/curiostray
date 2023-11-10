extends State


@export var player: Player
@export var drill_ray: DrillRay


func physics_update(_delta: float) -> void:
	var drill_direction := player.get_local_mouse_position()
	if drill_direction.length() < player.interactive_range:
		drill_ray.show_ray_to_point(drill_direction)
	else:
		drill_ray.hide()


func exit() -> void:
	drill_ray.hide()
