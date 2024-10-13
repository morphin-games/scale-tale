class_name PPStateActionWalljump
extends PPStateAction

@export var jump_force : float = 18.0
@export var speed : float = 1.75

func ready() -> void:
	var context : PPContextPlatformer = (platformer_pawn_state.state_machine as PPStateMachine).context as PPContextPlatformer
	
	(platformer_pawn_state.platformer_pawn._controller as PlayerController).kxi_jump_pressed.connect(Callable(func() -> void:
		if(!platformer_pawn_state.active): return
		
		(platformer_pawn_state.state_machine as PPStateMachine).input_bufferer.buffer("kxi_jump", 
		Callable(func() -> void:
			context.velocity_y = jump_force
			var force : float = context.return_speed * speed
			var platformer_control_context : PlatformerControlContext = platformer_pawn_state.platformer_pawn.context as PlatformerControlContext
			var last_direction : Vector2 = platformer_control_context.last_direction
			context.fixed_xz_velocity = -last_direction * force
			platformer_pawn_state.platformer_pawn.body.velocity.x = context.fixed_xz_velocity.x
			platformer_pawn_state.platformer_pawn.body.velocity.z = context.fixed_xz_velocity.y
			platformer_control_context.direction_angle = last_direction.angle() + deg_to_rad(90)
			platformer_control_context.last_direction *= -1
		), Callable(func() -> bool:
			return (
				platformer_pawn_state.platformer_pawn.body.is_on_wall_only()
			)
		))
	))
	
