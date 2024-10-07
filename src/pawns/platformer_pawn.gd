class_name PlatformerPawn
extends Pawn3D

@export var body : CharacterBody3D
@export_category("Stats")
@export var max_speed : float = 30.0
@export var max_acceleration : float = 0.5

@onready var velocity_y : float = 0.0
@onready var speed : float = max_speed
@onready var acceleration : float = max_acceleration
@onready var platformer_controller : PlayerController = _controller as PlayerController
@onready var platformer_control_context : PlatformerControlContext = context as PlatformerControlContext

var input_bufferer : InputBufferer = InputBufferer.new()
var fixed_xz_velocity : Vector2 = Vector2(0.0, 0.0)

# Virtual function. Called on ready.
# Override to add your behaviour.
func ready() -> void:
	add_child(input_bufferer)

# Virtual function. Called on input.
# Override to add your behaviour.
func input(event: InputEvent) -> void:
	pass
	
# Virtual function. Called every frame.
# Override to add your behaviour.
func process(delta : float) -> void:
	body.velocity.y = velocity_y
	fixed_xz_velocity = fixed_xz_velocity.move_toward(platformer_control_context.direction * speed, acceleration)
	body.velocity.x = fixed_xz_velocity.x
	body.velocity.z = fixed_xz_velocity.y
	
# Virtual function. Called every physics frame.
# Override to add your behaviour.
func physics_process(delta : float) -> void:
	body.move_and_slide()
