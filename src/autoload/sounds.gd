extends Node


func start_digging() -> void:
	if not $DigSound.playing:
		$DigSound.play()


func stop_digging() -> void:
	$DigSound.stop()


func start_moving() -> void:
	if not $MoveSound.playing:
		$MoveSound.play()


func stop_moving() -> void:
	$MoveSound.stop()


func upgrade() -> void:
	$UpgradeSound.play()


func repair() -> void:
	$RepairSound.play()


func spawn() -> void:
	if not $UpgradeSound.playing:
		$SpawnSound.play()


func place_block() -> void:
	$PlaceBlockSound.play()
