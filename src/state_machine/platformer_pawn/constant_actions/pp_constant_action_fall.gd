class_name PPConstantActionFall
extends PPConstantAction

var gravity = ProjectSettings.get("physics/3d/default_gravity")

func process(delta : float) -> void:
	if(
		state_machine.platformer_pawn.body.is_on_floor()
	):
		state_machine.platformer_pawn.velocity_y == 0
	else:
		state_machine.platformer_pawn.velocity_y -= gravity
		
