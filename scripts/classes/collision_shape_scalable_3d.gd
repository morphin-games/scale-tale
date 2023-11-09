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
	if(shape is SphereShape3D):
		original_radius = (shape as SphereShape3D).radius
	if(shape is CylinderShape3D or shape is CapsuleShape3D):
		original_height = (shape as CylinderShape3D).height
		
func _process(delta: float) -> void:
	scale = scale / scalable_3d.current_scale.x
	
	if(shape is BoxShape3D):
		(shape as BoxShape3D).size = scalable_3d.current_scale * original_size * optional_extra_scaling
	if(shape is SphereShape3D):
		(shape as SphereShape3D).radius = ((scalable_3d.current_scale.x * original_radius) / 2) * optional_extra_scaling
	if(shape is CylinderShape3D or shape is CapsuleShape3D):
		(shape as CylinderShape3D).height = scalable_3d.current_scale.x * original_height * optional_extra_scaling
