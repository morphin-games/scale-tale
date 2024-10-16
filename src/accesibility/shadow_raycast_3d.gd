class_name ShadowRayCast3D
extends RayCast3D

@export var shadow_texture : Texture2D
@export var shadow_size : Vector3 = Vector3(1, 1, 1)

var shadow : Decal = Decal.new()

func _ready() -> void:
	shadow.texture_albedo = shadow_texture
	shadow.size = shadow_size
	shadow.lower_fade = 0.01
	shadow.upper_fade = 0.01
	add_child(shadow)

func _process(delta: float) -> void:
	if(is_colliding()):
		shadow.global_transform.origin.y = get_collision_point().y - (shadow_size.y / 2.0) + 0.01
