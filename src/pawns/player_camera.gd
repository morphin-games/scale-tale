class_name PlayerCamera
extends Camera3D

var pawn : PlatformerPawn
var controller : PlayerController
var camera_rotation_pivot_x : Node3D
var camera_rotation_pivot_y : Node3D

func _process(delta: float) -> void:
	camera_rotation_pivot_x.global_transform.origin = pawn.global_transform.origin
	camera_rotation_pivot_x.rotation_degrees.x += controller.player_control_context.camera_motion.x
	camera_rotation_pivot_y.rotation_degrees.y += controller.player_control_context.camera_motion.y
	global_transform.origin.x = camera_rotation_pivot_y.global_transform.origin.x
	global_transform.origin.y = lerp(global_transform.origin.y, pawn.body.global_transform.origin.y + controller.camera_y_offset, controller.camera_follow_speed)
	global_transform.origin.z = camera_rotation_pivot_y.global_transform.origin.z
	look_at(pawn.body.global_transform.origin - global_transform.origin) 
