class_name Spawner3D
extends Marker3D

@export var spawn_on_ready : bool = false
@export var scene : PackedScene
@export_enum("None", "EnemySpawners", "ItemSpawners") var subgroup : String = "None"

func _ready() -> void:
	add_to_group(subgroup)
	if(spawn_on_ready):
		await get_tree().create_timer(2.0).timeout
		spawn()

func spawn() -> Node3D:
	var inst : Node3D = scene.instantiate()
	get_parent().add_child(inst)
	inst.global_transform.origin = global_transform.origin
	return inst
