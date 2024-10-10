class_name PPStateClimbingEdge
extends PPState

var forced_direction : Vector2 = Vector2(0.0, 0.0)

func enter_condition() -> bool:
	return (
		state_machine.state is PPStateClimbingEdge and 
		!platformer_pawn.body.is_on_floor()
	)

#func exit() -> void:
	#var context : PPContextPlatformer = (state_machine as PPStateMachine).context as PPContextPlatformer
	#context.speed = context.return_speed
	#context.acceleration = context.return_acceleration
	#context.acceleration = context.return_acceleration
