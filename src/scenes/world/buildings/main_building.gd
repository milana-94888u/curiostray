class_name MainBuilding
extends Building


signal player_upgraded(level: int)


@export var first_needed_ingdidients: Array[CrafringIngridient]
@export var second_needed_ingdidients: Array[CrafringIngridient]


@export var current_level := 1:
	set(value):
		current_level = value
		if not is_node_ready():
			await ready
		match current_level:
			1:
				upgrade_ask.recipe = first_needed_ingdidients
			2:
				upgrade_ask.recipe = second_needed_ingdidients
			3:
				upgrade_ask.queue_free()


@onready var upgrade_ask := $UpgradeAsk as UpgradeAsk


func _ready() -> void:
	player_upgraded.emit(current_level)


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if is_instance_valid(upgrade_ask):
			upgrade_ask.show()


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		if is_instance_valid(upgrade_ask):
			upgrade_ask.hide()


func _on_upgrade_ask_upgraded() -> void:
	current_level += 1
	player_upgraded.emit(current_level)
