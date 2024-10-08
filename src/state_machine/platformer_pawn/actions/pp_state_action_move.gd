class_name PPStateActionMove
extends PPStateAction

@export var angle_acceleration : float = 0.279

func process(delta : float) -> void:
	if(!platformer_pawn_state.active): return
	
	var context : PPContextPlatformer = (platformer_pawn_state.state_machine as PPStateMachine).context as PPContextPlatformer
	context.fixed_xz_velocity = context.fixed_xz_velocity.move_toward(
		platformer_pawn_state.platformer_pawn.platformer_control_context.direction * context.speed,
		context.acceleration
	)
	
	var final_angle : float = platformer_pawn_state.platformer_pawn.platformer_control_context.direction_angle 
	platformer_pawn_state.platformer_pawn.mesh.rotation.y = lerp_angle(platformer_pawn_state.platformer_pawn.mesh.rotation.y, -final_angle, angle_acceleration)
	platformer_pawn_state.platformer_pawn.body.velocity.x = context.fixed_xz_velocity.x
	platformer_pawn_state.platformer_pawn.body.velocity.z = context.fixed_xz_velocity.y
	
