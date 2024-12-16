extends StaticBody3D
class_name Frog

@onready var audio = $AudioStreamPlayer3D

func strike():
	audio.play()
