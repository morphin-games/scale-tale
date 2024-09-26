class_name PlayerCamera
extends Camera3D

var pawn : PlatformerPawn
var controller : PlayerController
var camera_rotation_pivot_x : Node3D
var camera_rotation_pivot_y : Node3D

func _process(delta: float) -> void:
	camera_rotation_pivot_x.global_transform.origin = pawn.body.global_transform.origin # TODO: Lerp this
	camera_rotation_pivot_x.transform.origin.y = controller.camera_y_offset
	camera_rotation_pivot_y.transform.origin.z = -controller.camera_distance
	camera_rotation_pivot_x.rotation_degrees.y -= controller.player_control_context.camera_motion.x
	camera_rotation_pivot_x.rotation_degrees.x += controller.player_control_context.camera_motion.y
	controller.player_control_context.camera_look_direction = Vector2.RIGHT.rotated(camera_rotation_pivot_x.rotation.y + deg_to_rad(90)).normalized()
	global_transform.origin = camera_rotation_pivot_y.global_transform.origin
	look_at(pawn.body.global_transform.origin, Vector3(0, 1, 0))
	controller.player_control_context.camera_motion = Vector2(0.0, 0.0)
