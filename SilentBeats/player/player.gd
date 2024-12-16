extends XROrigin3D

@export var max_distance = 20.0
@export var fade_distance = 0.02


func pose_recentered():
	XRServer.center_on_hmd(XRServer.RESET_BUT_KEEP_TILT, false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var distance = $XRCamera3D.position.length()
	
	if distance > max_distance:
		$XRCamera3D/BlackOut.fade = clamp((distance - max_distance) / 0.05, 0.0, 1.0)
		$XRCamera3D/PressToCenter.visible = true
	else:
		$XRCamera3D/BlackOut.fade = 0
		$XRCamera3D/PressToCenter.visible = false
