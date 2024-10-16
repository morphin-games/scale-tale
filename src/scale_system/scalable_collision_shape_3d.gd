class_name ScalableCollisionShape3D
## Simple tool class to preconfigure collision shapes.
extends CollisionShape3D

func _ready() -> void:
	shape.resource_local_to_scene = true
