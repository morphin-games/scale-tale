class_name PPStateMachine
## A specialized [StateMachine] to handle [PPState].
extends StateMachine

## The actions that will be constantly executed, independently from the current [member state].
@export var constant_actions : Array[PPConstantAction]
## The actions that will be constantly executed, independently from the current [member state].
@export var context : PPContext

## The parent [PlatformerPawn], available for every [PPState] and their [PPStateAction]
@onready var platformer_pawn : PlatformerPawn = get_parent() as PlatformerPawn if get_parent() is PlatformerPawn else null
## [InputBufferer] available for every [PPState] and their [PPStateAction].
@onready var input_bufferer : InputBufferer = InputBufferer.new()

## Sets up every [PPState] and [PPConstantAction].
func setup() -> void:
	add_child(input_bufferer)
	for iterated in states:
		if(iterated == null): continue
		(iterated as PPState).state_machine = self
		(iterated as PPState).platformer_pawn = platformer_pawn
		(iterated as PPState).setup_actions()
		
	for constant_action in constant_actions:
		(constant_action as PPConstantAction).ready()
		(constant_action as PPConstantAction).state_machine = self
		
func _process(delta: float) -> void:
	print((context as PPContextPlatformer).speed)
	print((context as PPContextPlatformer).acceleration)
	print("----------------------------------")
	#print(state.resource_path)
	super(delta)
	for iterated in states:
		if(iterated == null): continue
		for action in (iterated as PPState).state_actions:
			action.process(delta)
		
	for constant_action in constant_actions:
		constant_action.process(delta)
