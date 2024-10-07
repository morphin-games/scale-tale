class_name PPStateActionDive
extends PPStateAction

@export var jump_force : float = 8.0
## The speed of the player when jumping. It's multiplied by [member PlatformerPawn.return_speed].
@export var push_force : float = 1.75
## The acceleration of the push. It's multiplied by [member PlatformerPawn.return_acceleration].
@export var push_acceleration : float = 5.0

func ready() -> void:
	(platformer_pawn_state.platformer_pawn._controller as PlayerController).kxi_run_pressed.connect(Callable(func() -> void:
		if(!platformer_pawn_state.active): return
		if(platformer_pawn_state.platformer_pawn.platformer_control_context.direction == Vector2(0.0, 0.0)): return
		
		for state in platformer_pawn_state.state_machine.states:
			if(state is PPStateDiving):
				platformer_pawn_state.platformer_pawn.velocity_y += jump_force
				platformer_pawn_state.state_machine.state = state
				return
				
		push_warning("PPStateActionDive tried to force PPStateDiving in a PPStateMachine that doesn't have that state!")
	))
