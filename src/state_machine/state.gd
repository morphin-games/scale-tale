class_name State
extends Resource

var active : bool = false
var state_machine : StateMachine

func enter_condition() -> bool:
	return false

func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
func process(delta : float) -> void:
	pass
	
