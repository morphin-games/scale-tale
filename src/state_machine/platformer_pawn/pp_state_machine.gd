class_name PPStateMachine
extends StateMachine

@export var constant_actions : Array[PPConstantAction]

@onready var platformer_pawn : PlatformerPawn = get_parent() as PlatformerPawn if get_parent() is PlatformerPawn else null
@onready var input_bufferer : InputBufferer = InputBufferer.new()

func setup() -> void:
	add_child(input_bufferer)
	for iterated in states:
		if(iterated == null): continue
		(iterated as PPState).state_machine = self
		(iterated as PPState).platformer_pawn = platformer_pawn
		(iterated as PPState).setup_actions()
		
	for constant_action in constant_actions:
		(constant_action as PPConstantAction).state_machine = self 
		
func _process(delta: float) -> void:
	super(delta)
	for constant_action in constant_actions:
		constant_action.process(delta)
