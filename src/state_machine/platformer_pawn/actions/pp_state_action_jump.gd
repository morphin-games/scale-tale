class_name PPStateActionJump
extends PPStateAction

@export var jump_force : float = 40.0

func ready() -> void:
	(platformer_pawn_state.platformer_pawn._controller as PlatformerController).kxi_jump_pressed.connect(Callable(func() -> void:
		if(!platformer_pawn_state.active): return
		
		(platformer_pawn_state.state_machine as PPStateMachine).input_bufferer.buffer("kxi_jump", 
		Callable(func() -> void:
			platformer_pawn_state.platformer_pawn.velocity_y = jump_force
		), Callable(func() -> bool:
			return platformer_pawn_state.platformer_pawn.body.is_on_floor()
		))
	))
