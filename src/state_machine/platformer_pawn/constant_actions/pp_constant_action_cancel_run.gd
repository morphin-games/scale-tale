class_name PPConstantActionCancelRun
extends PPConstantAction
	
func process(delta : float) -> void:
	var context : PPContextPlatformer = state_machine.context as PPContextPlatformer
	if(
		state_machine.platformer_pawn.floor_raycast.is_colliding() and
		!context.running
	):
		context.speed = context.return_speed
		
