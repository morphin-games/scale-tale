class_name GrabableRigid3D
extends Grabable3D

@export var throw_force : float = 20.0
#@export var y_impulse : float = 23.0

func _process(delta: float) -> void:
	if(player == null): return
	if(player.grabbed_item == null): return
	
	(player.grabbed_item as RigidBody3D).inertia = Vector3.ZERO
	(player.grabbed_item as RigidBody3D).linear_velocity = Vector3.ZERO
	(player.grabbed_item as RigidBody3D).angular_velocity = Vector3.ZERO
	
func _ungrab() -> void:
	if(player.grabbed_item == null): return 
	emit_signal("ungrabbed")
#	var current_camera : Camera3D = get_viewport().get_camera_3d()
#	if(current_camera != null):
#		if(current_camera is CameraFollow3D):
#			current_camera.distance = player.prev_cam_data.distance
#			current_camera.height = player.prev_cam_data.height
#			player.prev_cam_data = {}
			
	(player.grabbed_item as RigidBody3D).inertia = Vector3.ZERO
	(player.grabbed_item as RigidBody3D).linear_velocity = Vector3.ZERO
	(player.grabbed_item as RigidBody3D).angular_velocity = Vector3.ZERO
	set_colliders_disabled(false)
	(player.grabbed_item as RigidBody3D).freeze = false
	player.grabbed_item = null

func grab() -> void:
	if(player.grabbed_item == null):
		emit_signal("grabbed")
#		var current_camera : Camera3D = get_viewport().get_camera_3d()
#		if(current_camera != null):
#			if(current_camera is CameraFollow3D):
#				player.prev_cam_data = current_camera.get_prev_cam_data()
				
		player.grabbed_item = item
		set_colliders_disabled(true)
		(player.grabbed_item as RigidBody3D).freeze = true

func drop() -> void:
	if(player.grabbed_item != null):
		_ungrab()

func throw() -> void:
	_ungrab()
	var y_impulse : float = get_y_impulse()
	var direction : Vector3 = (player.get_node("GrabPivot/Grabbed").global_transform.origin - player.global_transform.origin).normalized()
	var player_movement_impulse : float = player.get_node("MovementPivot/Movement").transform.origin.x
	var player_movement_impulse_vector = Vector2(player_movement_impulse * direction.x, player_movement_impulse * direction.z) * 10
	(item as RigidBody3D).apply_impulse(Vector3((direction.x * throw_force) + player_movement_impulse_vector.x, y_impulse, (direction.z * throw_force) + player_movement_impulse_vector.y))
	
