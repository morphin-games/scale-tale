class_name DistanceEnabler3D
extends Area3D

@export var start_disabled : bool = true

func _ready() -> void:
	if(start_disabled):
		get_parent().set_process(false)
		get_parent().set_physics_process(false)
		for child in get_parent().get_children(true):
			child.set_process(false)
			child.set_physics_process(false)
	
	body_entered.connect(Callable(func(body : PhysicsBody3D) -> void:
		if(body.name == "Player"):
			get_parent().set_process(true)
			get_parent().set_physics_process(true)
			for child in get_parent().get_children(true):
				child.set_process(true)
				child.set_physics_process(true)
	))
	
	body_exited.connect(Callable(func(body : PhysicsBody3D) -> void:
		if(body.name == "Player"):
			get_parent().set_process(false)
			get_parent().set_physics_process(false)
			for child in get_parent().get_children(true):
				child.set_process(false)
				child.set_physics_process(false)
	))

