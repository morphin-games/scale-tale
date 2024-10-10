class_name GPUParticlesIPOS3D
extends GPUParticles3D

func _ready() -> void:
	one_shot = true
	emitting = true
	await get_tree().create_timer(10.0).timeout
	queue_free()
