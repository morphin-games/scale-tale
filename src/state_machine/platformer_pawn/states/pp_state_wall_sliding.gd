class_name PPStateWallSliding
extends PPState

@export var sliding_velocity : float = 5.0

func enter_condition() -> bool:
	var player_pawn : PlayerPawn = platformer_pawn as PlayerPawn
	var context : PPContextPlatformer = (state_machine as PPStateMachine).context as PPContextPlatformer
	return (
		player_pawn.edge_hang_top.is_colliding() and
		player_pawn.edge_hang_low.is_colliding() and 
		player_pawn.body.is_on_wall_only() and 
		context.velocity_y < 0.0
	)
	
func enter() -> void:
	var context : PPContextPlatformer = (state_machine as PPStateMachine).context as PPContextPlatformer
	var player_pawn : PlayerPawn = platformer_pawn as PlayerPawn
	context.gravity = 0.0
	context.velocity_y = 0.0
	context.fixed_xz_velocity = Vector2(0.0, 0.0)
	player_pawn.body.velocity.x = context.fixed_xz_velocity.x
	player_pawn.body.velocity.z = context.fixed_xz_velocity.y
	#var tween_velocity : Tween = player_pawn.get_tree().create_tween()
	#tween_velocity.tween_property(context, "velocity_y", -sliding_velocity, 0.4)
	context.velocity_y = -sliding_velocity
	
func exit() -> void:
	var context : PPContextPlatformer = (state_machine as PPStateMachine).context as PPContextPlatformer
	context.gravity = context.return_gravity
