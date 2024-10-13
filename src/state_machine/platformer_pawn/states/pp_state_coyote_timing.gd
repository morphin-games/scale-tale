class_name PPStateCoyoteTiming
extends PPState

func enter_condition() -> bool:
	return (
		((state_machine as PPStateMachine).context as PPContextPlatformer).coyote_time >= 0.0 and
		!platformer_pawn.body.is_on_floor() and 
		state_machine.state is not PPStateJumping
	)

func enter() -> void:
	pass
