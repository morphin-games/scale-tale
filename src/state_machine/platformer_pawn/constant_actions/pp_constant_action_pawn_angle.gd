class_name PPConstantActionPawnAngle
extends PPConstantAction

@export var angle_acceleration : float = 0.279

func process(delta: float) -> void:
	var final_angle : float = state_machine.platformer_pawn.platformer_control_context.direction_angle 
	var body : CharacterBody3D = state_machine.platformer_pawn.body
	body.rotation.y = lerp_angle(body.rotation.y, -final_angle, angle_acceleration)
