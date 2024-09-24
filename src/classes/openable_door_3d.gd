class_name OpenableDoor3D
extends Node3D

func open() -> void:
	var tween_l : Tween = get_tree().create_tween()
	tween_l.tween_property($HingeLeft, "rotation_degrees:y", 77.5, 1.0)
	
	var tween_r : Tween = get_tree().create_tween()
	tween_r.tween_property($HingeRight, "rotation_degrees:y", -75.0, 1.0)
	
func close() -> void:
	var tween_l : Tween = get_tree().create_tween()
	tween_l.tween_property($HingeLeft, "rotation_degrees:y", 0.0, 1.0)
	
	var tween_r : Tween = get_tree().create_tween()
	tween_r.tween_property($HingeRight, "rotation_degrees:y", 0.0, 1.0)
