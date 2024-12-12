extends XRController3D

signal pose_recentered

@export var max_tracking_distance = 0.5

@onready var anchor = $Anchor
@onready var drumstick = $Anchor/DrumStickBody

var was_visible = false
var last_hit_object : Object

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pose = "hand_pose"
	drumstick.top_level = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var hit_object : Node3D
	
	visible = get_has_tracking_data()

	if visible:
		var start_transform : Transform3D = drumstick.global_transform
		var target_transform : Transform3D = anchor.global_transform
		var motion : Vector3 = target_transform.origin - drumstick.global_position
		
		if !was_visible or (target_transform.origin - drumstick.global_position).length() > max_tracking_distance:
			drumstick.global_transform = target_transform
		else:
			# Copy the orientation
			drumstick.global_basis = target_transform.basis
			
			var collision = drumstick.move_and_collide(motion)
			
			if collision:
				hit_object = collision.get_collider()
				if !hit_object:
					# Not hitting anything
					pass
				elif !last_hit_object or hit_object != last_hit_object:
					# Hit something new
					if hit_object is DrumInstrument:
						# var velocity = get_pose().linear_velocity.length()
						var hit_position = collision.get_position()
						
						var hit_local = drumstick.global_transform.inverse() * hit_position
						var hit_start = start_transform * hit_position
						var hit_end = target_transform * hit_position
						
						var velocity = (hit_end - hit_start).length() / delta
						
						#$Anchor/DrumStickBody/TestLabel.text = "%0.3f m/s" % velocity
						
						hit_object.strike(velocity)
		
	
	was_visible = visible
	last_hit_object = hit_object

func _on_button_pressed(name: String) -> void:
	if name == "pose_recenter":
		emit_signal("pose_recentered")
