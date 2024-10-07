class_name PPStateActionMove
extends PPStateAction

func process(delta : float) -> void:
	if(!platformer_pawn_state.active): return
	
	var context : PPContextPlatformer = (platformer_pawn_state.state_machine as PPStateMachine).context as PPContextPlatformer
	context.fixed_xz_velocity = context.fixed_xz_velocity.move_toward(
		platformer_pawn_state.platformer_pawn.platformer_control_context.direction * context.speed,
		context.acceleration
	)
	
	platformer_pawn_state.platformer_pawn.body.velocity.x = context.fixed_xz_velocity.x
	platformer_pawn_state.platformer_pawn.body.velocity.z = context.fixed_xz_velocity.y
