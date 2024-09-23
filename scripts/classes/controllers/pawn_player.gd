class_name PawnPlayer
extends Pawn

@export var body : CharacterBody3D
@export var max_speed : float = 50.0
@export var jump_height : float = 50.0

var momentum : Vector2

func _set_enabled() -> void:
	set_process(controller == null && body == null)
	set_physics_process(controller == null && body == null)

func _move(direction : Vector2) -> void:
	body.velocity.x = (direction * max_speed).normalized().x
	body.velocity.z = (direction * max_speed).normalized().y
	
	body.move_and_slide()
	
	
