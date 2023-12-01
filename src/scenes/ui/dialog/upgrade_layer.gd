class_name UpgradeLayer
extends CanvasLayer


@onready var animation_player := $AnimationPlayer as AnimationPlayer


func upgrade(to_level: int) -> void:
	$ColorRect/NewLevelLabel.text = "Upgraded player to level %d" % to_level
	get_tree().paused = true
	animation_player.play("upgrade")
	await animation_player.animation_finished
	get_tree().paused = false
