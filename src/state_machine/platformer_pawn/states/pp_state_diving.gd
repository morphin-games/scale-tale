class_name PPStateDiving
extends PPState

var forced_direction : Vector2 = Vector2(0.0, 0.0)

func enter_condition() -> bool:
	return (
		state_machine.state is PPStateDiving and 
		!platformer_pawn.floor_raycast.is_colliding()
	)

func process(delta : float) -> void:
	print(platformer_pawn.body.velocity)

func exit() -> void:
	var context : PPContextPlatformer = (state_machine as PPStateMachine).context as PPContextPlatformer
	context.dived = false
	context.speed = context.return_speed
	context.acceleration = context.return_acceleration
