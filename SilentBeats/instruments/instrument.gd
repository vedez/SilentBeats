extends StaticBody3D
class_name DrumInstrument


# set up the sound
@export var strike_sound : AudioStream:
	set(value):
		strike_sound = value
		if is_inside_tree():
			_update_strike_sound()

# assinging max strike speed and volume curve
@export var max_strike_velocity : float = 32.0
@export var strike_volume_curve : Curve

# assign the audio file to the audio stream
func _update_strike_sound():
	$StrikePlayer3D.stream = strike_sound


# strike the instrument
func strike(strike_velocity : float):
	var strike_factor = clamp(strike_velocity / max_strike_velocity, 0.0, 1.0)
	var volume = strike_volume_curve.sample_baked(strike_factor)
	
	$StrikePlayer3D.volume_db = volume
	$StrikePlayer3D.play()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_strike_sound()
