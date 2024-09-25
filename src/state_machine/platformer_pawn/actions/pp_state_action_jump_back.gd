class_name PPStateActionJumpBack
extends PPStateAction

@export var jump_force : float = 80.0

func ready() -> void:
	(platformer_pawn_state.platformer_pawn._controller as PlatformerController).kxi_jump_pressed.connect(Callable(func() -> void:
		if(platformer_pawn_state.active):
			platformer_pawn_state.platformer_pawn.velocity_y = jump_force
			print("BACK")
	))

#func process(delta : float) -> void:
	#
