@tool
class_name ScalableProjectileAttractionField3D
extends Area3D

@export var scalable : Scalable3D

func _ready() -> void:
	collision_layer = CollisionLayerNames.SCALABLE_ATTRACTION_FIELD
	collision_mask = CollisionLayerNames.SCALE_PROJECTILE
	if(Engine.is_editor_hint()): return
	
	area_entered.connect(Callable(func(area : Area3D) -> void:
		var projectile : ProjectileScale = area.get_parent() as ProjectileScale
		var projectile_data : ProjectileDataScale = projectile.projectile_data as ProjectileDataScale
		
		if(scalable.scale_state == scalable.ScaleState.LARGE and projectile_data.scale_state == projectile_data.ScaleState.UP):
			return
		if(scalable.scale_state == scalable.ScaleState.SMALL and projectile_data.scale_state == projectile_data.ScaleState.DOWN):
			return
		if(
			scalable.scale_state == scalable.ScaleState.DEFAULT and
			projectile_data.scale_state == projectile_data.ScaleState.UP and
			!scalable.scale_large_enabled
		):
			return
		if(
			scalable.scale_state == scalable.ScaleState.DEFAULT and
			projectile_data.scale_state == projectile_data.ScaleState.DOWN and
			!scalable.scale_small_enabled
		):
			return
		
		projectile_data.direction = (global_transform.origin - projectile.global_transform.origin).normalized()
	))
