extends FiniteStateMachine


@onready var idle_state := $IdleState as State
@onready var fall_state := $FallState as State
@onready var horizontal_move_state := $HorizontalMoveState as State
@onready var fly_state := $FlyState as State


func _on_idle_state_fall_started() -> void:
	transition_to(fall_state)


func _on_fall_state_landed() -> void:
	transition_to(idle_state)


func _on_idle_state_movement_started(x_direction: float) -> void:
	transition_to(horizontal_move_state, x_direction)


func _on_horizontal_move_state_fall_started() -> void:
	transition_to(fall_state)


func _on_horizontal_move_state_stopped() -> void:
	transition_to(idle_state)


func _on_idle_state_fly_started() -> void:
	transition_to(fly_state)


func _on_fly_state_fall_started() -> void:
	transition_to(fall_state)


func _on_horizontal_move_state_fly_started() -> void:
	transition_to(fly_state)
