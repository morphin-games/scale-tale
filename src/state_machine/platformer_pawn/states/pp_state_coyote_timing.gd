class_name PPStateCoyoteTiming
extends PPState

func enter_condition() -> bool:
	return (
		((state_machine as PPStateMachine).context as PPContextPlatformer).coyote_time >= 0.0 and
		!platformer_pawn.body.is_on_floor()
	)

func enter() -> void:
	#print("COYOTE")
	pass
