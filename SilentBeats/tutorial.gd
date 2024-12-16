extends Node3D

@onready var label : Label3D = $TutorialLabel
@onready var drumtracks = [$Tracks/Drumtrack1, $Tracks/Drumtrack2, $Tracks/Drumtrack3]
@onready var drumdisplays = [$Displays/Display1, $Displays/Display2, $Displays/Display3]
@onready var tutorial_options = ["Bread 'n Butter (92bpm)", "Beatle Bits (100bpm)", "Spacey Stuff (105bpm)"]
@onready var tutorial : bool = false

var current_option : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_scene()

func _setup_scene():
	# assign current track to 0 and hide the text
	current_option = 0
	label.visible = false
	
	_hide_all_tracks()
	
	# update drum track text
	_update_label()

func _update_label():
	if label:
		label.text = tutorial_options[current_option]

func _play_sample():
	drumtracks[current_option].play()

func _stop_sample():
	drumtracks[current_option].stop()

func _show_track():
	_hide_all_tracks()
	drumdisplays[current_option].visible = true
	

func _hide_all_tracks():
	for i in range(0, 3):
		drumdisplays[i].visible = false

func _on_stick_right() -> void:
	if !tutorial:
		return
		
	_stop_sample()
		
	if current_option == 2:
		current_option = 0
	else:
		current_option += 1
	
	_play_sample()
	_show_track()
	_update_label()

func _on_stick_left() -> void:
	if !tutorial:
		return 
		
	_stop_sample()
	
	if current_option == 0:
		current_option = 2
	else:
		current_option -= 1
	
	_play_sample()
	_show_track()
	_update_label()
	


func _on_tutorial_enabled() -> void:
	tutorial = !tutorial
	
	if tutorial:
		_play_sample()
		_show_track()
		_update_label()
		
		label.visible = true
	else:
		_hide_all_tracks()
		_stop_sample()
		label.visible = false
