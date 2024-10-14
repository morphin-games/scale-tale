class_name StateMachine
extends Node

signal state_changed(state : State)

@export var states : Array[State]

@onready var state : State = states[0] if states.size() > 0 else null : 
	set(new_state):
		if((new_state.get_script() as GDScript).get_global_name() == (state.get_script() as GDScript).get_global_name()):
			return
		state.exit()
		state.active = false
		state = new_state
		state.enter()
		state.active = true
		state_changed.emit(state)

func setup() -> void:
	pass
	
func _ready() -> void:
	setup()

func _process(delta: float) -> void:
	for iterated in states:
		if(iterated.enter_condition()):
			state = iterated
			break
	
	if(state == null): return
	
	state.process(delta)
	
## Method to force a certain state. [br][br]
## Returns [member @GlobalScope.Error.OK] if state was forced successfully.[br]
## Returns [member @GlobalScope.Error.FAILED] if state couldn't be forced.
func force_state(state_class : StringName) -> int:
	for iterated_state in states:
		if((iterated_state.get_script() as GDScript).get_global_name() == state_class):
			state = iterated_state
			return OK
				
	return FAILED
