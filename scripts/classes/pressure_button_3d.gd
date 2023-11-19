class_name PressureButton3D
extends Node3D

signal pressed
signal unpressed

@export var admit_any_body : bool = true

func _on_area_3d_body_entered(body: Node3D) -> void:
	if(body.name == "Player" or admit_any_body):
		emit_signal("pressed")
		var p_tween : Tween = get_tree().create_tween()
		p_tween.tween_property($Button, "transform:origin:y", -0.05, 0.25)


func _on_area_3d_body_exited(body: Node3D) -> void:
	if(body.name == "Player" or admit_any_body):
		emit_signal("unpressed")
		var p_tween : Tween = get_tree().create_tween()
		p_tween.tween_property($Button, "transform:origin:y", 0.1, 0.25)
		
