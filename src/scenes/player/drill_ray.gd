class_name DrillRay
extends Line2D


var in_radius_flag := false:
	set(value):
		in_radius_flag = value
		check_flags()
var mouse_held_flag := false:
	set(value):
		mouse_held_flag = value
		check_flags()


func check_flags() -> void:
	if in_radius_flag and mouse_held_flag:
		BlockBreakManager.breaking_started.emit()
	else:
		BlockBreakManager.breaking_stopped.emit()


func show_ray_to_point(point: Vector2) -> void:
	show()
	points = [Vector2.ZERO, point]


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			mouse_held_flag = true
		elif event.is_released():
			mouse_held_flag = false


func _on_visibility_changed() -> void:
	in_radius_flag = visible
