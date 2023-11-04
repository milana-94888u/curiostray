class_name DrillRay
extends Line2D


func show_ray_to_point(point: Vector2) -> void:
	show()
	points = [Vector2.ZERO, point]


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			BlockBreakManager.breaking_started.emit()
		elif event.is_released():
			BlockBreakManager.breaking_stopped.emit()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
