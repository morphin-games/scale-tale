class_name PPStateRunning
extends PPState

## The minimum speed considered as "running"
@export var speed_treshold : float

func enter_condition() -> bool:
	return (
		platformer_pawn.platformer_control_context.direction != Vector2(0.0, 0.0) and 
		platformer_pawn.speed >= speed_treshold
	)

func enter() -> void:
	platformer_pawn.acceleration = platformer_pawn.return_acceleration

func exit() -> void:
	platformer_pawn.speed = platformer_pawn.return_speed
