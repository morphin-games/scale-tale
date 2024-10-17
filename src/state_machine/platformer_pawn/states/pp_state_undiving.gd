class_name PPStateUndiving
extends PPState

func enter_condition() -> bool:
	return (
		(state_machine as PPStateMachine).state is PPStateUndiving and
		!platformer_pawn.floor_raycast.is_colliding()
	)
	
#func enter() -> void:
	#pass

func exit() -> void:
	print("ESIT")
	var context : PPContextPlatformer = (state_machine as PPStateMachine).context as PPContextPlatformer
	context.dived = false
