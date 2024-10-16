class_name PPStateActionDive
extends PPStateAction

@export var jump_force : float =  3.0
## The speed of the player when jumping. It's multiplied by [member PlatformerPawn.return_speed].
@export var push_force : float = 2.0
# ## The acceleration of the push. It's multiplied by [member PlatformerPawn.return_acceleration].
#@export var push_acceleration : float = 1000.0

func ready() -> void:
	var context : PPContextPlatformer = (platformer_pawn_state.state_machine as PPStateMachine).context as PPContextPlatformer
	
	(platformer_pawn_state.platformer_pawn._controller as PlayerController).kxi_run_pressed.connect(Callable(func() -> void:
		if(!platformer_pawn_state.active): return
		if(context.dived): return
		if(platformer_pawn_state.platformer_pawn.platformer_control_context.direction == Vector2(0.0, 0.0)): return
		
		context.dived = true
		
		var force_status : Error = platformer_pawn_state.state_machine.force_state("PPStateDiving")
		if(force_status == OK):
			context.velocity_y += jump_force
			var force : float = context.return_speed * push_force
			context.fixed_xz_velocity = platformer_pawn_state.platformer_pawn.platformer_control_context.direction * force
			platformer_pawn_state.platformer_pawn.body.velocity.x = context.fixed_xz_velocity.x
			platformer_pawn_state.platformer_pawn.body.velocity.z = context.fixed_xz_velocity.y
			return
		
		push_warning("PPStateActionDive tried to force PPStateDiving in a PPStateMachine that doesn't have that state!")
	))
