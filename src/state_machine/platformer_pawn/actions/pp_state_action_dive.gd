class_name PPStateActionDive
extends PPStateAction

func ready() -> void:
	(platformer_pawn_state.platformer_pawn._controller as PlayerController).kxi_run_pressed.connect(Callable(func() -> void:
		if(!platformer_pawn_state.active): return
		
		print("DIVE")
	))
	
