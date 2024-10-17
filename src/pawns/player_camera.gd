class_name PlayerCamera
extends Camera3D

var pawn : PlatformerPawn
var controller : PlayerController
var camera_rotation_pivot_x : Node3D
var camera_rotation_pivot_y : Node3D
var time_since_camera_adjustment : float = 0.0

func _process(delta: float) -> void:
	camera_rotation_pivot_x.global_transform.origin = pawn.body.global_transform.origin # TODO: Lerp this
	camera_rotation_pivot_x.transform.origin.y = pawn.body.global_transform.origin.y + controller.camera_y_offset
	camera_rotation_pivot_y.transform.origin.z = -controller.camera_distance
	camera_rotation_pivot_x.rotation_degrees.y -= controller.player_control_context.camera_motion.x
	camera_rotation_pivot_x.rotation_degrees.x += controller.player_control_context.camera_motion.y
	controller.player_control_context.camera_look_direction = Vector2.RIGHT.rotated(camera_rotation_pivot_x.rotation.y + deg_to_rad(90)).normalized()
	global_transform.origin = camera_rotation_pivot_y.global_transform.origin
	look_at(pawn.body.global_transform.origin, Vector3(0, 1, 0))
	controller.player_control_context.camera_motion = Vector2(0.0, 0.0)
	
	if(time_since_camera_adjustment > 0.0):
		time_since_camera_adjustment -= delta
	else:
		pass
		# TODO: Fix camera follow
		#var forward_vector : Vector3 = -pawn.body.global_basis.z
		#var angle_redirection : float = Vector2(forward_vector.x, forward_vector.z).angle()
		#print("angle_redirection: ", angle_redirection)
		#camera_rotation_pivot_x.rotation.y = move_toward(
			#camera_rotation_pivot_x.rotation.y,
			#angle_redirection,
			#0.008
		#)
