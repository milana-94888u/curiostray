extends State


@export var player: Player


func physics_update(_delta: float) -> void:
	if player.left_raycast.is_colliding() and not player.right_raycast.is_colliding():
		# enable right engine
		player.player_data.energy -= 1
	elif player.right_raycast.is_colliding() and not player.left_raycast.is_colliding():
		player.player_data.energy -= 1
	var move_direction := Input.get_axis("left", "right")
	if move_direction:
		(get_parent() as FiniteStateMachine).transition_to(get_node("../HorizontalMoveState"))


#func process_input(event: InputEvent) -> void:
#	var 
