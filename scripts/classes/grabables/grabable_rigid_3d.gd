class_name GrabableRigid3D
extends Grabable3D

@export var throw_force : float = 20.0
@export var y_impulse : float = 23.0

func throw() -> void:
	player.grabbed_item = null
	var direction : Vector3 = (player.get_node("GrabPivot/Grabbed").global_transform.origin - player.global_transform.origin).normalized()
	var player_movement_impulse : float = player.get_node("MovementPivot/Movement").transform.origin.x
	var player_movement_impulse_vector = Vector2(player_movement_impulse * direction.x, player_movement_impulse * direction.z) * 10
	(item as RigidBody3D).apply_impulse(Vector3((direction.x * throw_force) + player_movement_impulse_vector.x, y_impulse, (direction.z * throw_force) + player_movement_impulse_vector.y))
