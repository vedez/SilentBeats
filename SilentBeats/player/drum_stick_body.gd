extends CharacterBody3D
class_name Stick

@export var strike_sound : AudioStream:
	set(value):
		strike_sound = value
		if is_inside_tree():
			_update_strike_sound()

func _update_strike_sound():
	$StrikePlayer3D.stream = strike_sound

func strike():
	$StrikePlayer3D.play()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_strike_sound()
