class_name PPStateActionScale
extends PPStateAction

var projectile_up : PackedScene = preload("res://scenes/projectiles/scale_up.tscn")
var projectile_down : PackedScene = preload("res://scenes/projectiles/scale_down.tscn")

func ready() -> void:
	var context : PPContextPlatformer = (platformer_pawn_state.state_machine as PPStateMachine).context as PPContextPlatformer
	
	(platformer_pawn_state.platformer_pawn._controller as PlayerController).kxi_upscale_pressed.connect(Callable(func() -> void:
		if(!platformer_pawn_state.active): return
		
		var projectile_instance : Projectile = projectile_up.instantiate()
		var projectile_data : ProjectileDataScale = ProjectileDataScale.new()
		projectile_data.direction.x = platformer_pawn_state.platformer_pawn.platformer_control_context.last_direction.x
		projectile_data.direction.z = platformer_pawn_state.platformer_pawn.platformer_control_context.last_direction.y
		projectile_data.scale_state = projectile_data.ScaleState.UP
		projectile_instance.setup(projectile_data)
		platformer_pawn_state.platformer_pawn.get_parent().add_child(projectile_instance)
		projectile_instance.global_transform.origin = platformer_pawn_state.platformer_pawn.body.global_transform.origin
	))
	
	(platformer_pawn_state.platformer_pawn._controller as PlayerController).kxi_downscale_pressed.connect(Callable(func() -> void:
		if(!platformer_pawn_state.active): return
		
		var projectile_instance : Projectile = projectile_up.instantiate()
		var projectile_data : ProjectileDataScale = ProjectileDataScale.new()
		projectile_data.direction.x = platformer_pawn_state.platformer_pawn.platformer_control_context.last_direction.x
		projectile_data.direction.z = platformer_pawn_state.platformer_pawn.platformer_control_context.last_direction.y
		projectile_data.scale_state = projectile_data.ScaleState.DOWN
		projectile_instance.setup(projectile_data)
		platformer_pawn_state.platformer_pawn.get_parent().add_child(projectile_instance)
		projectile_instance.global_transform.origin = platformer_pawn_state.platformer_pawn.body.global_transform.origin
	))
