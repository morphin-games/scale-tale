class_name ALPatrol
extends ActionLeaf

@export var player_detection_distance : float = 20.0
@export var speed : float = 2.0
@export var max_patrol_time : float = 5.0 # TODO: Implement

func tick(actor: Node, blackboard: Blackboard) -> int:
	var controller : BasicEnemyController = actor as BasicEnemyController
	var context : PlatformerControlContext = (actor as BasicEnemyController).control_context as PlatformerControlContext
	var pawn : PlatformerPawn = controller.pawn as PlatformerPawn
	var direction_vector : Vector3 = (blackboard.get_value("patrol_point") - pawn.body.global_transform.origin).normalized()
	context.direction = Vector2(direction_vector.x, direction_vector.z)
	pawn.body.velocity.x = context.direction.x * speed
	pawn.body.velocity.z = context.direction.y * speed
	
	if(pawn.body.global_transform.origin.distance_to((LevelManager.level as LevelBase).player_pawn.body.global_transform.origin) < player_detection_distance):
		return FAILURE
	else:
		return RUNNING
