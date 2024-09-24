class_name RigidContactSound3D
extends Node3D

@export var contact_sfx : AudioStreamPlayer3D

#func _ready() -> void:
#	(get_parent() as RigidBody3D).body_entered.connect(Callable(func(body : PhysicsBody3D) -> void:
#		contact_sfx.play()
#	))
