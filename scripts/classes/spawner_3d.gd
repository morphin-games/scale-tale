class_name Spawner3D
extends Marker3D

@export var spawn_on_ready : bool = false
@export var scene : PackedScene
@export var subgroup : String

func _ready() -> void:
	add_to_group(subgroup)
	if(spawn_on_ready):
		await get_tree().create_timer(2.0).timeout
		spawn()

func spawn() -> void:
	var inst : Node3D = scene.instantiate()
	inst.global_transform.origin = global_transform.origin
	get_parent().add_child(inst)
