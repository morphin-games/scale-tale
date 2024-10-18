class_name CLPlayerNear
extends ConditionLeaf

@export var max_distance : float = 20.0

func tick(actor: Node, blackboard: Blackboard) -> int:
	if(((actor as BasicEnemyController).pawn as PlatformerPawn).body.global_transform.origin.distance_to((LevelManager.level as LevelBase).player_pawn.body.global_transform.origin) < max_distance):
		return SUCCESS
	else:
		return FAILURE
