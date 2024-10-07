class_name PPStateActionRun
extends PPStateAction

@export var speed_multiplier : float = 1.5
@export var accel_multiplier : float = 2.0

func ready() -> void:
	(platformer_pawn_state.platformer_pawn._controller as PlayerController).kxi_run_pressed.connect(Callable(func() -> void:
		if(!platformer_pawn_state.active): return
		
		platformer_pawn_state.platformer_pawn.speed *= speed_multiplier
		platformer_pawn_state.platformer_pawn.acceleration *= accel_multiplier
	))
	
	(platformer_pawn_state.platformer_pawn._controller as PlayerController).kxi_run_released.connect(Callable(func() -> void:
		platformer_pawn_state.platformer_pawn.speed = platformer_pawn_state.platformer_pawn.return_speed
		platformer_pawn_state.platformer_pawn.acceleration = platformer_pawn_state.platformer_pawn.return_acceleration
	))
	
