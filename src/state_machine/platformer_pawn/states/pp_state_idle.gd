class_name PPStateIdle
extends PPState

func enter_condition() -> bool:
	return (
		((state_machine as PPStateMachine).context as PPContextPlatformer).velocity_y == 0 and
		platformer_pawn.platformer_control_context.direction == Vector2(0.0, 0.0)
	)
