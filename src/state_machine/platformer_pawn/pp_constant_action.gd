class_name PPConstantAction
## A Constant Action is an action that's only related to a PPStateMachine.
## Every process() frame of its PPStateMachine, [method process] will be called.
extends Resource

var state_machine : PPStateMachine

func ready() -> void:
	pass

func process(delta : float) -> void:
	pass
