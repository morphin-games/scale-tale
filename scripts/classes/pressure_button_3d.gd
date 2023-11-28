class_name PressureButton3D
extends Node3D

signal pressed
signal unpressed

@export var admit_any_body : bool = true
@export_category("Audio")
@export var audio_stream : AudioStreamPlayer3D
@export var sound : AudioStreamWAV
@export var sound_only_once : bool = false

var sound_played : bool = false

func _ready() -> void:
	($Area3D as Area3D).body_entered.connect(Callable(func(body : Node3D) -> void:
		press(body)
		if(audio_stream != null):
			audio_stream.stream = sound
			if(sound_only_once and sound_played): return
			audio_stream.play()
	))
	
	($Area3D as Area3D).body_exited.connect(Callable(func(body : Node3D) -> void:
		unpress(body)
	))


func press(body : Node3D) -> void:
	if(body.name == "Player" or admit_any_body):
		emit_signal("pressed")
		var p_tween : Tween = get_tree().create_tween()
		p_tween.tween_property($Button, "transform:origin:y", -0.05, 0.25)
		
func unpress(body : Node3D) -> void:
	if(body.name == "Player" or admit_any_body):
		emit_signal("unpressed")
		var p_tween : Tween = get_tree().create_tween()
		p_tween.tween_property($Button, "transform:origin:y", 0.1, 0.25)
