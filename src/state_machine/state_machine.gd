class_name StateMachine
extends Node

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

func _ready() -> void:
	setup()

func setup() -> void:
	pass

func _process(delta: float) -> void:
	for iterated in states:
		if(iterated.enter_condition()):
			state = iterated
			break
	
	if(state == null): return
	
	state.process(delta)
