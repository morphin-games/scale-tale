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
	body.velocity.x = move_toward(body.velocity.x, platformer_control_context.direction.x * speed, acceleration)
	body.velocity.y = velocity_y
	body.velocity.z = move_toward(body.velocity.z, platformer_control_context.direction.y * speed, acceleration)
	
# Virtual function. Called every physics frame.
# Override to add your behaviour.
func physics_process(delta : float) -> void:
	body.move_and_slide()
