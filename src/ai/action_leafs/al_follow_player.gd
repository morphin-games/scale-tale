class_name ALFollowPlayer
extends ActionLeaf

@export var speed : float = 4.5
@export var follow_distance : float = 16.0

func tick(actor: Node, blackboard: Blackboard) -> int:
	var controller : BasicEnemyController = actor as BasicEnemyController
	var context : PlatformerControlContext = (actor as BasicEnemyController).control_context as PlatformerControlContext
	var pawn : PlatformerPawn = controller.pawn as PlatformerPawn
	var direction_vector : Vector3 = ((LevelManager.level as LevelBase).player_pawn.body.global_transform.origin - pawn.body.global_transform.origin).normalized()
	context.direction = Vector2(direction_vector.x, direction_vector.z)
	pawn.body.velocity.x = context.direction.x * speed
	pawn.body.velocity.z = context.direction.y * speed
	if(pawn.body.global_transform.origin.distance_to((LevelManager.level as LevelBase).player_pawn.body.global_transform.origin) < follow_distance):
		return RUNNING
	else:
		pawn.body.velocity.x = 0.0
		pawn.body.velocity.z = 0.0
		return FAILURE
