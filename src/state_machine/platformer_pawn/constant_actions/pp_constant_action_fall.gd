class_name PPConstantActionFall
extends PPConstantAction

#var gravity : float = ProjectSettings.get("physics/3d/default_gravity") as float

func process(delta : float) -> void:
	var context : PPContextPlatformer = (state_machine.context as PPContextPlatformer)
	
	if(context.coyote_time > 0.0):
		context.coyote_time -= delta
		
	if(state_machine.platformer_pawn.floor_raycast.is_colliding()):
		context.coyote_time = context.return_coyote_time
		
	if(context.jumping):
		context.jump_force = move_toward(context.jump_force, 0.0, 0.1)
		context.velocity_y += context.jump_force
		
	if(state_machine.state is not PPStateJumping):
		context.jumping = false
	
	if(
		state_machine.platformer_pawn.floor_raycast.is_colliding() and
		state_machine.state is not PPStateJumping and
		context.coyote_time > 0
	):
		context.velocity_y = 0.0
	elif(!state_machine.platformer_pawn.floor_raycast.is_colliding()):
		if(
			context.coyote_time <= 0.0 or 
			state_machine.state is PPStateJumping
		):
			context.velocity_y -= context.gravity
			
	state_machine.platformer_pawn.body.velocity.y = context.velocity_y
