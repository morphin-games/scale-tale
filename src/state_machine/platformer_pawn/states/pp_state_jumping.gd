class_name PPStateJumping
extends PPState

func enter_condition() -> bool:
	return (
		platformer_pawn.velocity_y > 0
	)
