class_name PPConstantActionFall
extends PPConstantAction

var gravity = ProjectSettings.get("physics/3d/default_gravity")

func process(delta : float) -> void:
	if(
		state_machine.platformer_pawn.body.is_on_floor() and
		state_machine.state is not PPStateJumping
	):
		state_machine.platformer_pawn.velocity_y = 0
	elif(!state_machine.platformer_pawn.body.is_on_floor()):
		state_machine.platformer_pawn.velocity_y -= gravity
		
