class_name ALFollowPlayer
extends ActionLeaf

@export var follow_distance : float = 20.0

func tick(actor: Node, blackboard: Blackboard) -> int:
	var direction : Vector3 = (((actor as BasicEnemyController).pawn as PlatformerPawn).body.global_transform.origin - (LevelManager.level as LevelBase).player_pawn.body.global_transform.origin).normalized()
	print("ac: ", actor.control_context)
	((actor as BasicEnemyController).control_context as PlatformerControlContext).direction = Vector2(direction.x, direction.z)
	if(((actor as BasicEnemyController).pawn as PlatformerPawn).body.global_transform.origin.distance_to((LevelManager.level as LevelBase).player_pawn.body.global_transform.origin) < follow_distance):
		return RUNNING
	else:
		return FAILURE
