class_name PPStateActionJump
extends PPStateAction

@export var jump_force : float = 12.0

func ready() -> void:
	var context : PPContextPlatformer = (platformer_pawn_state.state_machine as PPStateMachine).context as PPContextPlatformer
	
	(platformer_pawn_state.platformer_pawn._controller as PlayerController).kxi_jump_pressed.connect(Callable(func() -> void:
		if(!platformer_pawn_state.active): return
		
		(platformer_pawn_state.state_machine as PPStateMachine).input_bufferer.buffer("kxi_jump", 
		Callable(func() -> void:
			context.velocity_y = jump_force
		), Callable(func() -> bool:
			return (
				platformer_pawn_state.platformer_pawn.floor_raycast.is_colliding() or
				platformer_pawn_state.state_machine.state is PPStateCoyoteTiming
			)
		))
	))
	
