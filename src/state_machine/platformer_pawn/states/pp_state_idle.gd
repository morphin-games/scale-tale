class_name PPStateIdle
extends PPState

func enter_condition() -> bool:
	var context : PPContextPlatformer = (state_machine as PPStateMachine).context as PPContextPlatformer
	return (
		context.velocity_y == 0 and
		(context.coyote_time <= 0 or context.coyote_time == context.return_coyote_time) and
		platformer_pawn.platformer_control_context.direction == Vector2(0.0, 0.0)
	)
	
func enter() -> void:
	var context : PPContextPlatformer = (state_machine as PPStateMachine).context as PPContextPlatformer
	context.gravity = context.return_gravity
