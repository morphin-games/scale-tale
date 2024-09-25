class_name PlatformerPawnStateMachine
extends StateMachine

@onready var platformer_pawn : PlatformerPawn = get_parent() if get_parent() is PlatformerPawn else null

func setup() -> void:
	for iterated in states:
		if(iterated == null): continue
		(iterated as PlatformerPawnState).platformer_pawn = platformer_pawn
