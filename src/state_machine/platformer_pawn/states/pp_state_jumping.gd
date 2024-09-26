class_name PPStateJumping
extends PPState

func enter_condition() -> bool:
	return (
		platformer_pawn.velocity_y > 0
	)

func enter() -> void:
	platformer_pawn.acceleration = platformer_pawn.max_acceleration / 4
	
func exit() -> void:
	platformer_pawn.acceleration = platformer_pawn.max_acceleration
