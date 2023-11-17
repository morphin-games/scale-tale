class_name ScaleParticles
extends Node3D

func emit(enabled : bool) -> void:
	print(global_transform.origin)
	for child in get_children():
		(child as GPUParticles3D).emitting = enabled
