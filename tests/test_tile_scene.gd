extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_static_body_2d_mouse_entered() -> void:
	print("entered")
	modulate = Color.RED


func _on_static_body_2d_mouse_exited() -> void:
	modulate = Color.WHITE
