class_name PPStateJumping
extends PPState

func enter_condition() -> bool:
	return (
		((state_machine as PPStateMachine).context as PPContextPlatformer).velocity_y > 0
	)

func enter() -> void:
	var context : PPContextPlatformer = (state_machine as PPStateMachine).context as PPContextPlatformer
	context.acceleration = context.return_acceleration / 4
	
func exit() -> void:
	var context : PPContextPlatformer = (state_machine as PPStateMachine).context as PPContextPlatformer
	context.acceleration = context.return_acceleration
