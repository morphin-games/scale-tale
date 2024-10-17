class_name PPStateActionRun
extends PPStateAction

@export var speed_multiplier : float = 1.85
@export var accel_multiplier : float = 2.0

func ready() -> void:
	var context : PPContextPlatformer = (platformer_pawn_state.state_machine as PPStateMachine).context as PPContextPlatformer
	
	(platformer_pawn_state.platformer_pawn._controller as PlayerController).kxi_run_pressed.connect(Callable(func() -> void:
		if(!platformer_pawn_state.active): return
		
		context.speed = context.return_speed * speed_multiplier
		context.acceleration = context.return_acceleration * accel_multiplier
		context.running = true
	))
	
	(platformer_pawn_state.platformer_pawn._controller as PlayerController).kxi_run_released.connect(Callable(func() -> void:
		#if(!platformer_pawn_state.active): return
		#context.speed = context.return_speed
		#context.acceleration = context.return_acceleration
		context.running = false
	))
	
