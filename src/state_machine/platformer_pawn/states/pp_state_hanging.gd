class_name PPStateHanging
extends PPState

func enter_condition() -> bool:
	var player_pawn : PlayerPawn = platformer_pawn as PlayerPawn
	return (
		!player_pawn.edge_hang_top.is_colliding() and
		player_pawn.edge_hang_low.is_colliding() and 
		player_pawn.body.is_on_wall_only()
	)
	
func enter() -> void:
	var context : PPContextPlatformer = (state_machine as PPStateMachine).context as PPContextPlatformer
	var player_pawn : PlayerPawn = platformer_pawn as PlayerPawn
	context.gravity = 0.0
	context.velocity_y = 0.0
	context.fixed_xz_velocity = Vector2(0.0, 0.0)
	player_pawn.body.velocity.x = context.fixed_xz_velocity.x
	player_pawn.body.velocity.z = context.fixed_xz_velocity.y
	var collision_normal_2d : Vector2 = Vector2(player_pawn.edge_hang_low.get_collision_normal().x, player_pawn.edge_hang_low.get_collision_normal().z)
	var tween : Tween = player_pawn.get_tree().create_tween()
	# TODO: Fix player rotation on hang
	#platformer_pawn.mesh.global_rotation.y = collision_normal_2d.angle()
	#var angle : float = rad_to_deg(collision_normal_2d.angle())
	#if(angle < 0):
		#angle += 180
	#print(angle)
	#player_pawn.mesh.rotation.y = collision_normal_2d.angle()
	#tween.tween_property(player_pawn.mesh, "global_rotation:y", collision_normal_2d.angle(), 0.1)
	#player_pawn.body.look_at(player_pawn.edge_hang_low.get_collision_normal())
