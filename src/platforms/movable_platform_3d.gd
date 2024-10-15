class_name MovablePlatform3D
extends CharacterBody3D

func _physics_process(delta: float) -> void:
	move_and_slide()
