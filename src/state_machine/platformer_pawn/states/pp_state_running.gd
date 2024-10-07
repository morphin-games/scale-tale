class_name PPStateRunning
extends PPState

## The minimum speed considered as "running"
@export var speed_treshold : float

func enter_condition() -> bool:
	return (
		platformer_pawn.platformer_control_context.direction != Vector2(0.0, 0.0) and 
		((state_machine as PPStateMachine).context as PPContextPlatformer).speed >= speed_treshold
	)

func enter() -> void:
	((state_machine as PPStateMachine).context as PPContextPlatformer).acceleration = ((state_machine as PPStateMachine).context as PPContextPlatformer).return_acceleration

func exit() -> void:
	((state_machine as PPStateMachine).context as PPContextPlatformer).speed = ((state_machine as PPStateMachine).context as PPContextPlatformer).return_speed
