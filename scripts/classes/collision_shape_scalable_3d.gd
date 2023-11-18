class_name CollisionShapeScalable3D
extends CollisionShape3D

@export var scalable_3d : Scalable3D
@export var optional_extra_scaling : float = 1.0

var original_size : Vector3
var original_radius : float
var original_height : float

func _ready() -> void:
	if(shape is BoxShape3D):
		original_size = (shape as BoxShape3D).size
		shape = BoxShape3D.new()
		shape.size = original_size
		((scalable_3d.particles.get_child(0) as GPUParticles3D).process_material as ParticleProcessMaterial).emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	if(shape is SphereShape3D):
		original_radius = (shape as SphereShape3D).radius
		shape = SphereShape3D.new()
		shape.radius = original_radius
		((scalable_3d.particles.get_child(0) as GPUParticles3D).process_material as ParticleProcessMaterial).emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_SPHERE
	if(shape is CylinderShape3D):
		original_height = (shape as CylinderShape3D).height
		shape = CylinderShape3D.new()
		shape.height = original_height
		((scalable_3d.particles.get_child(0) as GPUParticles3D).process_material as ParticleProcessMaterial).emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_SPHERE
	elif(shape is CapsuleShape3D):
		original_height = (shape as CapsuleShape3D).height
		shape = CapsuleShape3D.new()
		shape.height = original_height
		((scalable_3d.particles.get_child(0) as GPUParticles3D).process_material as ParticleProcessMaterial).emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_SPHERE
		
func _process(delta: float) -> void:
	scale = scale / scalable_3d.current_scale.x
	
	if(shape is BoxShape3D):
		(shape as BoxShape3D).size = scalable_3d.current_scale * original_size * optional_extra_scaling
		((scalable_3d.particles.get_child(0) as GPUParticles3D).process_material as ParticleProcessMaterial).emission_box_extents = Vector3(scalable_3d.current_scale.x, scalable_3d.current_scale.y, scalable_3d.current_scale.z)
	if(shape is SphereShape3D):
		(shape as SphereShape3D).radius = ((scalable_3d.current_scale.x * original_radius) / 2) * optional_extra_scaling
		((scalable_3d.particles.get_child(0) as GPUParticles3D).process_material as ParticleProcessMaterial).emission_sphere_radius = scalable_3d.current_scale.x / 2
	if(shape is CylinderShape3D or shape is CapsuleShape3D):
		(shape as CylinderShape3D).height = scalable_3d.current_scale.x * original_height * optional_extra_scaling
