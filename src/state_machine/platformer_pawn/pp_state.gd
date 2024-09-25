class_name PPState
extends State

@export var state_actions : Array[PPStateAction]

var platformer_pawn : PlatformerPawn

func setup_actions() -> void:
	for state_action in state_actions:
		state_action.platformer_pawn_state = self
		state_action.ready()
