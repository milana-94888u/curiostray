class_name FiniteStateMachine
extends Node

@export var initial_state: State

var current_state: State


func _ready() -> void:
	if not get_tree().root.is_node_ready():
		await get_tree().root.ready
	if is_instance_valid(initial_state):
		transition_to(initial_state)


func transition_to(target: State, message: Variant = null) -> void:
	if is_instance_valid(current_state):
		current_state.exit()
	current_state = target
	current_state.enter(message)


func _process(delta: float) -> void:
	if is_instance_valid(current_state):
		current_state.update(delta)


func _physics_process(delta: float) -> void:
	if is_instance_valid(current_state):
		current_state.physics_update(delta)


func _unhandled_input(event: InputEvent) -> void:
	if is_instance_valid(current_state):
		current_state.process_input(event)
