class_name PPStateBeginningGrab
extends PPState

@export var grab_time : float = 0.5

func enter_condition() -> bool:
	return (
		state_machine.state is PPStateBeginningGrab
	)

func enter() -> void:
	var context : PPContextPlatformer = (state_machine as PPStateMachine).context as PPContextPlatformer
	context.fixed_xz_velocity = Vector2(0.0, 0.0)
	platformer_pawn.body.velocity.x = context.fixed_xz_velocity.x
	platformer_pawn.body.velocity.z = context.fixed_xz_velocity.y
	await state_machine.get_parent().get_tree().create_timer(grab_time).timeout
	state_machine.force_state("PPStateIdle")
	(state_machine as PPStateMachine).force_substate("PPSubstateGrabbingGrabbable")
