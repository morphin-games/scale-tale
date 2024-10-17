class_name PPStateActionMove
extends PPStateAction

@export var angle_acceleration : float = 0.279

func process(delta : float) -> void:
	if(!platformer_pawn_state.active): return
	
	var context : PPContextPlatformer = (platformer_pawn_state.state_machine as PPStateMachine).context as PPContextPlatformer
	var platformer_control_context : PlatformerControlContext = platformer_pawn_state.platformer_pawn.platformer_control_context
	context.fixed_xz_velocity = context.fixed_xz_velocity.move_toward(
		platformer_pawn_state.platformer_pawn.platformer_control_context.direction * context.speed,
		context.acceleration
	)
	
	platformer_pawn_state.platformer_pawn.body.velocity.x = context.fixed_xz_velocity.x
	platformer_pawn_state.platformer_pawn.body.velocity.z = context.fixed_xz_velocity.y
	
	context.time_to_angle -= delta
	
	var angle_difference : float = abs(rad_to_deg(angle_difference(platformer_control_context.direction_angle, platformer_control_context.last_registered_direction_angle)))
	
#	Keep facing direction if jumping or falling
	if(
		(platformer_pawn_state.state_machine.state is PPStateJumping or
		platformer_pawn_state.state_machine.state is PPStateFalling) and 
		angle_difference >= 46.0
	):
		context.time_to_angle = context.return_time_to_angle
	if(context.time_to_angle >= 0.0):
		return
		
		
	var final_angle : float = platformer_control_context.direction_angle 
	platformer_pawn_state.platformer_pawn.body.rotation.y = lerp_angle(platformer_pawn_state.platformer_pawn.body.rotation.y, -final_angle, angle_acceleration)
	
