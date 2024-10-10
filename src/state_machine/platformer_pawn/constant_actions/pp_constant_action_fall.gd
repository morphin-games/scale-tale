class_name PPConstantActionFall
extends PPConstantAction

#var gravity : float = ProjectSettings.get("physics/3d/default_gravity") as float
var gravity : float = 0.49

func process(delta : float) -> void:
	var context : PPContextPlatformer = (state_machine.context as PPContextPlatformer)
	
	if(
		state_machine.platformer_pawn.body.is_on_floor() and
		state_machine.state is not PPStateJumping
	):
		context.velocity_y = 0
	elif(!state_machine.platformer_pawn.body.is_on_floor()):
		context.velocity_y -= gravity
		
	state_machine.platformer_pawn.body.velocity.y = context.velocity_y
