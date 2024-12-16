extends Node3D


func _on_start_vr_focus_gained() -> void:
	# automatic recenter when focus gained
	$RecenterTimer.start()
