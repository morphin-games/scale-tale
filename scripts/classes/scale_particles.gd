class_name ScaleParticles
extends Node3D

@onready var system_enabled : bool = true

var emitting : bool = false
var shape : Shape3D

func emit(enabled : bool) -> void:
	if(!system_enabled) : return
	emitting = enabled
	for child in get_children():
		(child as GPUParticles3D).emitting = enabled
		
func set_shape(new_shape : Shape3D) -> void:
	shape = new_shape
	for child in get_children():
		if(shape is BoxShape3D):
			((child as GPUParticles3D).process_material as ParticleProcessMaterial).emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
		elif(shape is SphereShape3D or shape is CapsuleShape3D or shape is CylinderShape3D):
			((child as GPUParticles3D).process_material as ParticleProcessMaterial).emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_SPHERE
		
func set_size(size : float) -> void:
	for child in get_children():
		if(shape is BoxShape3D):
			((child as GPUParticles3D).process_material as ParticleProcessMaterial).emission_box_extents = Vector3(size, size, size)
		elif(shape is SphereShape3D or shape is CapsuleShape3D or shape is CylinderShape3D):
			((child as GPUParticles3D).process_material as ParticleProcessMaterial).emission_sphere_radius = size / 2

func set_color(color : Color) -> void:
	for child in get_children():
		((child as GPUParticles3D).draw_pass_1.surface_get_material(0) as ShaderMaterial).set_shader_parameter("_shield_color", color)
		
func destroy() -> void:
	for child in get_children():
		(child as GPUParticles3D).emitting = false
		
	await(get_tree().create_timer(5.0).timeout)
	if(self != null):
		queue_free()
