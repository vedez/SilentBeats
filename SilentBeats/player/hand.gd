extends XRController3D

signal pose_recentered
signal metro_enabled
signal bpm_increased
signal bpm_decreased
signal tutorial_enabled
signal stick_right
signal stick_left

@export var max_tracking_distance = 0.5

@onready var anchor = $Anchor
@onready var drumstick = $Anchor/DrumStickBody
@onready var bass_drum = null

var was_visible = false
var last_hit_object : Object
var stick_released : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pose = "hand_pose"
	drumstick.top_level = true
	bass_drum = get_tree().root.get_child(0).find_child("BassDrum", true, true)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var hit_object : Node3D
	
	visible = get_has_tracking_data()
	
	$Anchor/DrumStickBody/CollisionShape3D.disabled = !visible

	if visible:
		var start_transform : Transform3D = drumstick.global_transform
		var target_transform : Transform3D = anchor.global_transform
		var motion : Vector3 = target_transform.origin - drumstick.global_position
		
		if !was_visible or (target_transform.origin - drumstick.global_position).length() > max_tracking_distance:
			drumstick.global_transform = target_transform
		else:
			# copy the orientation
			drumstick.global_basis = target_transform.basis
			
			var collision = drumstick.move_and_collide(motion) # move drumstick + collision
			
			if collision:
				hit_object = collision.get_collider()
				if !last_hit_object or hit_object != last_hit_object:
					# hit something new
					if hit_object is DrumInstrument:
						var hit_position = collision.get_position()
						
						# var hit_local = drumstick.global_transform.inverse() * hit_position # find coordinate of hit
						var hit_start = start_transform * hit_position
						var hit_end = target_transform * hit_position
						
						var velocity = (hit_end - hit_start).length() / delta # V = D / T
						
						hit_object.strike(velocity)
					elif hit_object is Stick or Frog:
						hit_object.strike()

	was_visible = visible
	last_hit_object = hit_object

func _on_button_pressed(name: String) -> void:
	# player clicked to recenter
	if name == "pose_recenter":
		emit_signal("pose_recentered")
	# player clicked bass hit button
	elif name == "bass_hit":
		if bass_drum:
				bass_drum.strike(32)
	# player clicked to toggle metronome
	elif name == "metro_enable":
		emit_signal("metro_enabled")
	# player increased bpm
	elif name == "increase_bpm":
		emit_signal("bpm_increased")
	# player decreased bpm
	elif name == "decrease_bpm":
		emit_signal("bpm_decreased")
	# player clicked to toggle tutorial
	elif name == "tutorial_enable":
		emit_signal("tutorial_enabled")
		

func _on_input_vector_2_changed(name: String, value: Vector2) -> void:
	# if thumbstick is moved
	if name == "thumbstick_direction":
		# if the x axis is pushed all the way to the right
		if value[0] > 0.95 and stick_released:
			stick_released = false
			emit_signal("stick_right")
		# if the x axis is pushed to the left
		elif value[0] <  -0.95 and stick_released:
			stick_released = false
			emit_signal("stick_left")
		
		# if stick is released
		if !value[0]:
			stick_released = true
