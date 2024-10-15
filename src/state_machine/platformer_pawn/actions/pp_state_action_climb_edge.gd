class_name PPStateActionClimbEdge
extends PPStateAction

func ready() -> void:
	var context : PPContextPlatformer = (platformer_pawn_state.state_machine as PPStateMachine).context as PPContextPlatformer
	
	(platformer_pawn_state.platformer_pawn._controller as PlayerController).kxi_jump_pressed.connect(Callable(func() -> void:
		if(!platformer_pawn_state.active): return
		
		var force_status : Error = platformer_pawn_state.state_machine.force_state("PPStateClimbingEdge")
		if(force_status == OK):
			var platformer_pawn : PlatformerPawn = platformer_pawn_state.platformer_pawn
			var platformer_control_context : PlatformerControlContext = platformer_pawn_state.platformer_pawn.context as PlatformerControlContext
			var tween_get_up : Tween = platformer_pawn.get_tree().create_tween()
			tween_get_up.tween_property(
				platformer_pawn.body,
				"global_transform:origin",
				platformer_pawn.body.global_transform.origin + Vector3(0.0, 1.75, 0.0),
				0.8
			)
			await tween_get_up.finished
			
			var tween_go_forward : Tween = platformer_pawn.get_tree().create_tween()
			tween_go_forward.tween_property(
				platformer_pawn.body,
				"global_transform:origin",
				platformer_pawn.body.global_transform.origin + Vector3(platformer_control_context.last_direction.x, 0.0, platformer_control_context.last_direction.y) * 1.0,
				0.333
			)
			await tween_go_forward.finished
			
			platformer_pawn_state.state_machine.force_state("PPStateIdle")
			
		push_warning("PPStateActionClimbEdge tried to force PPStateClimbingEdge in a PPStateMachine that doesn't have that state!")
	))
