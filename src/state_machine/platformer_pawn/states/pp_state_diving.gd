class_name PPStateDiving
extends PPState

var forced_direction : Vector2 = Vector2(0.0, 0.0)
# An instance of [PPStateActionDive] to get the needed values.
var pp_state_action_dive : PPStateActionDive = PPStateActionDive.new()

func enter_condition() -> bool:
	return (
		state_machine.state is PPStateDiving and 
		!platformer_pawn.body.is_on_floor()
	)

func enter() -> void:
	forced_direction = platformer_pawn.platformer_control_context.direction
	platformer_pawn.platformer_controller.enabled = false

func exit() -> void:
	#platformer_pawn.speed = platformer_pawn.return_speed
	platformer_pawn.acceleration = platformer_pawn.return_acceleration
	platformer_pawn.platformer_controller.enabled = true

func process(delta : float) -> void:
	platformer_pawn.platformer_control_context.direction = forced_direction
	platformer_pawn.speed = platformer_pawn.return_speed * pp_state_action_dive.push_force
	platformer_pawn.acceleration = platformer_pawn.return_speed * pp_state_action_dive.push_acceleration
