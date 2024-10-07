class_name Scalable3D
extends Area3D

enum ScaleState {
	DEFAULT,
	SMALL,
	LARGE
}

@export var targets : Array[Node3D]

@export var infinite_scale_duration : bool = false
@export var upscale_duration : float = 15.0
@export var downscale_duration : float = 15.0

@export_group("Scale vector3 percentages (default)")
@export var scale_default : Vector3 = Vector3(1.0, 1.0, 1.0)

@export_group("Scale vector3 percentages (small)")
@export var scale_small_enabled : bool = true
@export var scale_small : Vector3 = Vector3(0.5, 0.5, 0.5)

@export_group("Scale vector3 percentages (large)")
@export var scale_large_enabled : bool = true
@export var scale_large : Vector3 = Vector3(2.0, 2.0, 2.0)

@onready var target : Node3D = get_parent() as Node3D
@onready var scale_state : ScaleState = ScaleState.DEFAULT
@onready var time_scaled : float = 0.0

func _ready() -> void:
	collision_layer = CollisionLayerNames.SCALABLE
	collision_mask = CollisionLayerNames.SCALE_PROJECTILE
	
	area_entered.connect(Callable(func(area : Area3D) -> void:
		var projectile : ProjectileScale = area.get_parent() as ProjectileScale
		var projectile_data : ProjectileDataScale = projectile.projectile_data as ProjectileDataScale
		
		if(projectile_data.scale_state == projectile_data.ScaleState.UP):
			_upscale()
					
		if(projectile_data.scale_state == projectile_data.ScaleState.DOWN):
			_downscale()
	))

func _upscale() -> void:
	if(scale_state == ScaleState.DEFAULT):
		if(scale_large_enabled):
			scale_state = ScaleState.LARGE
			_apply_scale(scale_large)
			time_scaled = upscale_duration
	elif(scale_state == ScaleState.SMALL):
		scale_state = ScaleState.DEFAULT
		_apply_scale(scale_default)
	
func _downscale() -> void:
	if(scale_state == ScaleState.DEFAULT):
		if(scale_small_enabled):
			scale_state = ScaleState.SMALL
			_apply_scale(scale_small)
			time_scaled = downscale_duration
	elif(scale_state == ScaleState.LARGE):
		scale_state = ScaleState.DEFAULT
		_apply_scale(scale_default)
		
func _apply_scale(scale_size : Vector3) -> void:
	for target in targets:
		if(target is not Node3D):
			continue
			
		if(target is not CollisionShape3D):
			target.scale = scale_size
		else:
			var collision_shape_3d : CollisionShape3D = target as CollisionShape3D
			if(collision_shape_3d.shape is BoxShape3D):
				(collision_shape_3d.shape as BoxShape3D).size = scale_size
			elif(collision_shape_3d.shape is SphereShape3D):
				(collision_shape_3d.shape as SphereShape3D).radius = scale_size.x / 2
				

func _process(delta: float) -> void:
	if(time_scaled > 0.0 and scale_state != ScaleState.DEFAULT):
		time_scaled -= delta
		if(time_scaled <= 0.0):
			scale_state = ScaleState.DEFAULT
			_apply_scale(scale_default)
