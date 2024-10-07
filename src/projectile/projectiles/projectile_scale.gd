class_name ProjectileScale
extends Projectile

func area_hit(area : Area3D) -> void:
	queue_free()
