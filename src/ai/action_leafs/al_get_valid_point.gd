class_name ALGetValidPoint
extends ActionLeaf

func tick(actor: Node, blackboard: Blackboard) -> int:
	var controller : BasicEnemyController = actor as BasicEnemyController
	var context : PlatformerControlContext = (actor as BasicEnemyController).control_context as PlatformerControlContext
	var pawn : PlatformerPawn = controller.pawn as PlatformerPawn
	
	var rid : RID = (LevelManager.level as LevelBase).navigation_region.get_rid()
	var point : Vector3 = NavigationServer3D.region_get_random_point(rid, 1, false)
	blackboard.set_value("patrol_point", point)
	var path : PackedVector3Array = NavigationServer3D.map_get_path(rid, pawn.body.transform.origin, point, false)
	blackboard.set_value("patrol_path", path)
	return SUCCESS
