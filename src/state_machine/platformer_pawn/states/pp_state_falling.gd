class_name PPStateFalling
extends PPState

func enter_condition() -> bool:
	return (
		((state_machine as PPStateMachine).context as PPContextPlatformer).velocity_y < 0
	)
