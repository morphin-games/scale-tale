class_name PPStateActionDive
extends PPStateAction

@export var jump_force : float = 4.0
## The speed of the player when jumping. It's multiplied by [member PlatformerPawn.return_speed].
@export var push_force : float = 2.5
# ## The acceleration of the push. It's multiplied by [member PlatformerPawn.return_acceleration].
#@export var push_acceleration : float = 1000.0

func ready() -> void:
	var context : PPContextPlatformer = (platformer_pawn_state.state_machine as PPStateMachine).context as PPContextPlatformer
	
	(platformer_pawn_state.platformer_pawn._controller as PlayerController).kxi_run_pressed.connect(Callable(func() -> void:
		if(!platformer_pawn_state.active): return
		if(platformer_pawn_state.platformer_pawn.platformer_control_context.direction == Vector2(0.0, 0.0)): return
		
		for state in platformer_pawn_state.state_machine.states:
			if(state is PPStateDiving):
				context.velocity_y += jump_force
				#context.speed = context.return_speed * push_force
				var force : float = context.return_speed * push_force
				platformer_pawn_state.state_machine.state = state
				context.fixed_xz_velocity = platformer_pawn_state.platformer_pawn.platformer_control_context.direction * force
				platformer_pawn_state.platformer_pawn.body.velocity.x = context.fixed_xz_velocity.x
				platformer_pawn_state.platformer_pawn.body.velocity.z = context.fixed_xz_velocity.y
				return
				
		push_warning("PPStateActionDive tried to force PPStateDiving in a PPStateMachine that doesn't have that state!")
	))
	
