extends Node3D

@export var bpm : int = 120
@export var click_sound : AudioStream

@onready var timer : Timer = $MetroTimer
@onready var audio_player : AudioStreamPlayer3D = $MetroPlayer3D
@onready var label : Label3D = $MetroText

var indicator_mesh: MeshInstance3D 
var material : StandardMaterial3D
var metronome: bool = false


# Called when the node enters the scene tree for the first time
func _ready():
	# Find the MeshInstance3D dynamically (adjust the path as needed)
	indicator_mesh = $MetroIndicator
	timer.one_shot = false

	if indicator_mesh and label:
		material = indicator_mesh.get_active_material(0)
		set_mesh_color()
		update_text()

	if click_sound:
		audio_player.stream = click_sound

	update_timer_interval()


# button to enable metronome is pressed
func metro_enabled():
	# toggle metronome
	metronome = !metronome

	set_mesh_color()
	update_timer_interval()
	
	if metronome:
		timer.start()
	else:
		timer.stop()


func bpm_increased():
	if bpm < 300:
		bpm += 5

		update_text()
		update_timer_interval()

func bpm_decreased():
	if bpm > 5:
		bpm -= 5
		update_text()
		update_timer_interval()
	elif metronome:
		bpm = 0
		metro_enabled()


func set_mesh_color():
	if indicator_mesh and material:
		material.albedo_color = Color(0, 1, 0) if metronome else Color(1, 0, 0)


func update_timer_interval():
	if bpm > 0:
		timer.wait_time = 60.0 / float(bpm) # divide bpm by 60 seconds in a minute, returns a float
	else:
		if !timer.is_stopped():
			timer.stop()
			if metronome: metronome = false


func update_text():
	label.text = str(bpm, " BPM")


func _on_metro_timer_timeout() -> void:
	audio_player.play()
