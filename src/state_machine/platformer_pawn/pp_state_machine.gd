class_name PPStateMachine
## A specialized [StateMachine] to handle [PPState].
extends StateMachine

## The actions that will be constantly executed, independently from the current [member state].
@export var constant_actions : Array[PPConstantAction]
## The actions that will be constantly executed, independently from the current [member state].
@export var context : PPContext
## The substates to affect the associated [PPStateAnimator].
@export var substates : Array[PPSubstate]

## The parent [PlatformerPawn], available for every [PPState] and their [PPStateAction]
@onready var platformer_pawn : PlatformerPawn = get_parent() as PlatformerPawn if get_parent() is PlatformerPawn else null
## [InputBufferer] available for every [PPState] and their [PPStateAction].
@onready var input_bufferer : InputBufferer = InputBufferer.new()
## The current substate. Can be null.
@onready var substate : PPSubstate = substates[0] if substates.size() > 0 else null

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
	#print("STATE: ", state.resource_name)
	super(delta)
	for iterated in states:
		if(iterated == null): continue
		for action in (iterated as PPState).state_actions:
			action.process(delta)
		
	for constant_action in constant_actions:
		constant_action.process(delta)
		
## Method to force a certain substate. [br][br]
## Returns [member @GlobalScope.Error.OK] if substate was forced successfully.[br]
## Returns [member @GlobalScope.Error.FAILED] if substate couldn't be forced.
func force_substate(state_class : StringName) -> int:
	for iterated_state in substates:
		if((iterated_state.get_script() as GDScript).get_global_name() == state_class):
			substate = iterated_state
			return OK
				
	return FAILED
