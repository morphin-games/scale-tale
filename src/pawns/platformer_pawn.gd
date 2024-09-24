class_name PlatformerPawn
extends Pawn3D

@export var max_speed : float = 300.0
@export var jump_force : float = 75.0

var platformer_controller : PlatformerController = _controller as PlatformerController
var input_bufferer : InputBufferer = InputBufferer.new()

# Virtual function. Called on ready.
# Override to add your behaviour.
func ready() -> void:
	add_child(input_bufferer)
	
	platformer_controller.kxi_jump_pressed.connect(Callable(func() -> void:
		input_bufferer.buffer("kxi_jump", Callable(func() -> void:
			print("a")
		), Callable(func() -> bool:
			return true
		))
	))

# Virtual function. Called on input.
# Override to add your behaviour.
func input(event: InputEvent) -> void:
	pass
	
# Virtual function. Called every frame.
# Override to add your behaviour.
func process(delta : float) -> void:
	pass
	
# Virtual function. Called every physics frame.
# Override to add your behaviour.
func physics_process(delta : float) -> void:
	pass
