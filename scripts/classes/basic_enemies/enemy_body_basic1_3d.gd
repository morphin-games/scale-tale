class_name EnemyBodyBasic13D
extends EnemyBody3D

@export var scalable_3d : Scalable3D
@export var vulnerable_scale : Vector3 = Vector3(0.5, 0.5, 0.5)

var vulnerable : bool = false

func _ready() -> void:
	scalable_3d.scale_changed.connect(Callable(func(current_scale : Vector3) -> void:
		vulnerable = current_scale.x <= vulnerable_scale.x
		print(vulnerable)
	))
