class_name PPStateActionCancelDive
extends PPStateAction

@export var jump_force : float = 7.0

func ready() -> void:
	var context : PPContextPlatformer = (platformer_pawn_state.state_machine as PPStateMachine).context as PPContextPlatformer
	
	(platformer_pawn_state.platformer_pawn._controller as PlayerController).kxi_jump_pressed.connect(Callable(func() -> void:
		if(!platformer_pawn_state.active): return
		if(platformer_pawn_state.platformer_pawn.platformer_control_context.direction == Vector2(0.0, 0.0)): return
		
		var force_status : Error = platformer_pawn_state.state_machine.force_state("PPStateJumping")
		if(force_status == OK):
			if(context.velocity_y < jump_force):
				context.velocity_y = jump_force
			else:
				context.velocity_y += jump_force
			return
		
		push_warning("PPStateActionDive tried to force PPStateDiving in a PPStateMachine that doesn't have that state!")
	))
