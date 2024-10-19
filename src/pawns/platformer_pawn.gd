class_name PlatformerPawn
extends Pawn3D

@export var body : CharacterBody3D
@export var mesh : Node3D
@export var health : Health
@export var floor_raycast : RayCast3D

@onready var player_controller : PlayerController = _controller as PlayerController
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
#func process(delta : float) -> void:
	#body.velocity.x = (context as PlatformerControlContext).direction.x * 4.0
	#body.velocity.z = (context as PlatformerControlContext).direction.y * 4.0
	
# Virtual function. Called every physics frame.
# Override to add your behaviour.
func physics_process(delta : float) -> void:
	body.move_and_slide()
	
