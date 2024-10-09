class_name PPStateHanging
extends PPState

func enter_condition() -> bool:
	var player_pawn : PlayerPawn = platformer_pawn as PlayerPawn
	
	return (
		!player_pawn.edge_hang_top.is_colliding() and
		player_pawn.edge_hang_low.is_colliding() and 
		player_pawn.body.is_on_wall_only()
	)
	
func enter() -> void:
	#print("HANGING")
	((state_machine as PPStateMachine).context as PPContextPlatformer).gravity = 0.0
	((state_machine as PPStateMachine).context as PPContextPlatformer).velocity_y = 0.0
