class_name PPState
## Specialized [State].
## A [PPState] also holds an array of [PPStateAction].
## A [PPState] can only call the actions inside itself.
extends State

## The array of [PPStateAction] that a State can call.
@export var state_actions : Array[PPStateAction]

## The parent [PlatformerPawn]
var platformer_pawn : PlatformerPawn

## Sets up every [PPStateAction] when loaded inside the [PPStateMachine].
func setup_actions() -> void:
	for state_action in state_actions:
		state_action.platformer_pawn_state = self
		state_action.ready()
