class_name PPStateAction
## A [PPStateAction] holds logic that may be called when its parent [PPState] is active inside its [PPStateMachine].
extends Resource

## The parent [PPState].
var platformer_pawn_state : PPState

## Override this function to add your own logic when loading the action.
## If you are connecting a signal from a controller, use 'if(!platformer_pawn_state.active): return'.
func ready() -> void:
	pass

## Override this function to add your own process logic.
## Use 'if(!platformer_pawn_state.active): return' to prevent being processed when the parent [PPState] is inactive.
func process(delta : float) -> void:
	pass
