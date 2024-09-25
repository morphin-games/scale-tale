class_name PlatformerPawn
extends Pawn3D

@export var body : CharacterBody3D

@export_category("Stats")
@export var max_speed : float = 30.0
@export var jump_force : float = 40.0

@onready var velocity_y : float = 0.0
@onready var speed : float = max_speed
@onready var platformer_controller : PlatformerController = _controller as PlatformerController
@onready var platformer_control_context : PlatformerControlContext = context as PlatformerControlContext

var input_bufferer : InputBufferer = InputBufferer.new()

# Virtual function. Called on ready.
# Override to add your behaviour.
func ready() -> void:
	add_child(input_bufferer)
	#platformer_controller.kxi_jump_pressed.connect(Callable(func() -> void:
		#input_bufferer.buffer("kxi_jump", Callable(func() -> void:
			#velocity_y = jump_force
		#), Callable(func() -> bool:
			#return true
		#))
	#))

# Virtual function. Called on input.
# Override to add your behaviour.
func input(event: InputEvent) -> void:
	pass
	
# Virtual function. Called every frame.
# Override to add your behaviour.
func process(delta : float) -> void:
	#if(body.is_on_floor()):
		#velocity_y = 0
	#else:
		#velocity_y -= ProjectSettings.get("physics/3d/default_gravity") as float
		#
	body.velocity = Vector3(platformer_control_context.direction.x * speed, velocity_y, platformer_control_context.direction.y * speed)
	
# Virtual function. Called every physics frame.
# Override to add your behaviour.
func physics_process(delta : float) -> void:
	body.move_and_slide()
