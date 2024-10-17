class_name PPStateMoving
extends PPState

func enter_condition() -> bool:
	return (
		platformer_pawn.platformer_control_context.direction != Vector2(0.0, 0.0)
	)

func enter() -> void:
	((state_machine as PPStateMachine).context as PPContextPlatformer).acceleration = ((state_machine as PPStateMachine).context as PPContextPlatformer).return_acceleration
	((state_machine as PPStateMachine).context as PPContextPlatformer).dived = false
