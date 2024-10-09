@tool
class_name ScalableProjectileAttractionField3D
extends Area3D

func _ready() -> void:
	collision_layer = CollisionLayerNames.SCALABLE_ATTRACTION_FIELD
	collision_mask = CollisionLayerNames.SCALE_PROJECTILE
	if(Engine.is_editor_hint()): return
	
	area_entered.connect(Callable(func(area : Area3D) -> void:
		var projectile : ProjectileScale = area.get_parent() as ProjectileScale
		var projectile_data : ProjectileDataScale = projectile.projectile_data as ProjectileDataScale
		
		print("dir ", projectile_data.direction)
		projectile_data.direction = (global_transform.origin - projectile.global_transform.origin).normalized()
		print("dir ", projectile_data.direction)
	))
