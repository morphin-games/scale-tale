@tool
class_name Scalable3D
extends Area3D

enum ScaleState {
	DEFAULT,
	SMALL,
	LARGE
}

@export var attraction_field : ScalableProjectileAttractionField3D
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

@onready var scale_state : ScaleState = ScaleState.DEFAULT
@onready var time_to_unscale : float = 0.0

var default_scales : Dictionary
var tween_speed : float = 0.33
var tween_ease : Tween.EaseType = Tween.EaseType.EASE_OUT
var tween_trans : Tween.TransitionType = Tween.TransitionType.TRANS_BOUNCE

func _ready() -> void:
	collision_layer = CollisionLayerNames.SCALABLE
	collision_mask = CollisionLayerNames.SCALE_PROJECTILE
	if(Engine.is_editor_hint()): return
	
	if(get_children()[0] != null and get_children()[0] is CollisionShape3D):
		targets.append(get_children()[0])
		
	if(attraction_field != null and attraction_field.get_children()[0] != null and get_children()[0] is CollisionShape3D):
		targets.append(get_children()[0])
		
	# Save all default scales in a dictionary to return to use them in the future
	for i in range(0, targets.size()):
		if(targets[i] is not Node3D):
			continue
			
		if(targets[i] is not CollisionShape3D):
			default_scales[i] = targets[i].scale
		else:
			var collision_shape_3d : CollisionShape3D = targets[i] as CollisionShape3D
			if(collision_shape_3d.shape is BoxShape3D):
				default_scales[i] = (collision_shape_3d.shape as BoxShape3D).size
			elif(collision_shape_3d.shape is SphereShape3D):
				default_scales[i] =  (collision_shape_3d.shape as SphereShape3D).radius
	
	area_entered.connect(Callable(func(area : Area3D) -> void:
		var projectile : ProjectileScale = area.get_parent() as ProjectileScale
		var projectile_data : ProjectileDataScale = projectile.projectile_data as ProjectileDataScale
		
		if(projectile_data.scale_state == projectile_data.ScaleState.UP):
			_upscale()
					
		if(projectile_data.scale_state == projectile_data.ScaleState.DOWN):
			_downscale()
			
		projectile.queue_free()
	))

func _upscale() -> void:
	if(scale_state == ScaleState.DEFAULT):
		if(scale_large_enabled):
			scale_state = ScaleState.LARGE
			_apply_scale(scale_large)
			time_to_unscale = upscale_duration
	elif(scale_state == ScaleState.SMALL):
		scale_state = ScaleState.DEFAULT
		_apply_scale(scale_default)
	else:
		time_to_unscale = upscale_duration
	
func _downscale() -> void:
	if(scale_state == ScaleState.DEFAULT):
		if(scale_small_enabled):
			scale_state = ScaleState.SMALL
			_apply_scale(scale_small)
			time_to_unscale = downscale_duration
	elif(scale_state == ScaleState.LARGE):
		scale_state = ScaleState.DEFAULT
		_apply_scale(scale_default)
	else:
		time_to_unscale = downscale_duration
		
func _apply_scale(scale_size : Vector3) -> void:
	for i in range(0, targets.size()):
		if(targets[i] is not Node3D):
			continue
			
		if(targets[i] is not CollisionShape3D):
			var tween : Tween = get_tree().create_tween()
			tween.set_ease(tween_ease)
			tween.set_trans(tween_trans)
			tween.tween_property(targets[i], "scale", scale_size, tween_speed)
		else:
			var collision_shape_3d : CollisionShape3D = targets[i] as CollisionShape3D
			if(collision_shape_3d.shape is BoxShape3D):
				var tween : Tween = get_tree().create_tween()
				tween.set_ease(tween_ease)
				tween.set_trans(tween_trans)
				tween.tween_property((collision_shape_3d.shape as BoxShape3D), "size", scale_size, tween_speed)
			elif(collision_shape_3d.shape is SphereShape3D):
				var tween : Tween = get_tree().create_tween()
				tween.set_ease(tween_ease)
				tween.set_trans(tween_trans)
				tween.tween_property((collision_shape_3d.shape as SphereShape3D), "radius", scale_size.x / 2, tween_speed)
				
func _process(delta: float) -> void:
	if(Engine.is_editor_hint()): return
	
	if(time_to_unscale > 0.0 and scale_state != ScaleState.DEFAULT):
		time_to_unscale -= delta
		if(time_to_unscale <= 0.0):
			scale_state = ScaleState.DEFAULT
			_apply_scale(scale_default)
