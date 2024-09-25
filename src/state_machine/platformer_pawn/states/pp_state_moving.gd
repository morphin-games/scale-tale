class_name PPStateMoving
extends PPState

func enter_condition() -> bool:
	return (
		platformer_pawn.platformer_control_context.direction != Vector2.ZERO
	)

func enter() -> void:
	platformer_pawn.acceleration = platformer_pawn.max_acceleration
