class_name PlatformMover3D
extends Node3D

@export var platform : PlatformBody3D
@export var points : Array[Marker3D]
@export var speed : float = 4.0
@export var randomize : bool = false

var target_point_idx = 0
var direction : Vector3 = Vector3.ZERO

func _physics_process(delta: float) -> void:
	if(Utils.vectors_approx_equal(platform.global_transform.origin, points[target_point_idx].global_transform.origin, 0.5)):
		target_point_idx += 1
		if(target_point_idx >= points.size()):
			target_point_idx = 0
			
		direction = (points[target_point_idx].global_transform.origin - platform.global_transform.origin).normalized()
		
	platform.velocity = direction * speed
	platform.move_and_slide()
