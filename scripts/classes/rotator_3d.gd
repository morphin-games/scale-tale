class_name Rotator3D
extends Node

@export var rotation_speed : float = 1.0
@export_group("Rotation axis")
@export var x : bool = false
@export var y : bool = true
@export var z : bool = false

func _process(delta: float) -> void:
	if(get_parent() is Node3D):
		if(x):
			(get_parent() as Node3D).global_rotation.x += delta * rotation_speed
		if(y):
			(get_parent() as Node3D).global_rotation.y += delta * rotation_speed
		if(z):
			(get_parent() as Node3D).global_rotation.z += delta * rotation_speed
	else:
		queue_free()
