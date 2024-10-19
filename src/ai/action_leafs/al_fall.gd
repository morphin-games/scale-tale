class_name ALFall
extends ActionLeaf

@export var gravity : float = 0.49

func tick(actor: Node, blackboard: Blackboard) -> int:
	if(((actor as BasicEnemyController).pawn as PlatformerPawn).body.is_on_floor()):
		((actor as BasicEnemyController).pawn as PlatformerPawn).body.velocity.y = 0.0
	else:
		((actor as BasicEnemyController).pawn as PlatformerPawn).body.velocity.y -= gravity
	
	return RUNNING
