class_name PlatformerPawnStateMoving
extends PlatformerPawnState

func enter_condition() -> bool:
	return (
		platformer_pawn.velocity_y == 0 and
		platformer_pawn.platformer_control_context.direction != Vector2.ZERO
	)
