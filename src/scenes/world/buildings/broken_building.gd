extends Building


@export var needed_ingdidients: Array[CrafringIngridient]:
	set(new_recipe):
		needed_ingdidients = new_recipe
		if not is_node_ready():
			await ready
		repair_ask.recipe = new_recipe


@onready var repair_ask := $RepairAsk as RepairAsk


func _ready() -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		repair_ask.show()


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		repair_ask.hide()


func _on_repair_ask_repaired() -> void:
	pass # Replace with function body.
