class_name PPStateActionJump
extends PPStateAction

@export var jump_force : float = 1.0

func ready() -> void:
	var context : PPContextPlatformer = (platformer_pawn_state.state_machine as PPStateMachine).context as PPContextPlatformer
	
	(platformer_pawn_state.platformer_pawn._controller as PlayerController).kxi_jump_pressed.connect(Callable(func() -> void:
		if(!platformer_pawn_state.active): return
		
		(platformer_pawn_state.state_machine as PPStateMachine).input_bufferer.buffer("kxi_jump", 
		Callable(func() -> void:
			#context.velocity_y = jump_force
			#added_jump = jump_force
			#context.velocity_y = added_jump
			context.jumping = true
			context.jump_force = context.return_jump_force
			context.velocity_y = context.jump_force
		), Callable(func() -> bool:
			return (
				platformer_pawn_state.platformer_pawn.floor_raycast.is_colliding() or
				platformer_pawn_state.state_machine.state is PPStateCoyoteTiming
			)
		))
	))
	
	(platformer_pawn_state.platformer_pawn._controller as PlayerController).kxi_jump_released.connect(Callable(func() -> void:
		context.jumping = false
	))
	
#func process(delta : float) -> void:
	#if(!platformer_pawn_state.active): return
	##
	#print("STR")
	#var context : PPContextPlatformer = (platformer_pawn_state.state_machine as PPStateMachine).context as PPContextPlatformer
	#context.velocity_y += added_jump
	#added_jump = move_toward(added_jump, 0.0, 0.1)
