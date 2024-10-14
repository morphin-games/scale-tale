@tool
class_name Grabbable3D
extends Area3D

@onready var parent : Node3D = get_parent() as Node3D

func _ready() -> void:
	collision_layer = CollisionLayerNames.GRABABBLE
	collision_mask = CollisionLayerNames.GRABBER
	
	area_entered.connect(Callable(func(area : Grabber3D) -> void:
		area.near_grabbables.append(self)
	))
	
	area_exited.connect(Callable(func(area : Grabber3D) -> void:
		area.near_grabbables.erase(self)
	))
