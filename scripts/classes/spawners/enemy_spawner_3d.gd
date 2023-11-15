class_name EnemySpawner3D
extends Spawner3D

@export var root : Node3D

func spawn() -> void:
	var inst : EnemyBody3D = scene.instantiate()
	inst.player = Utils.get_player(root)
	inst.global_transform.origin = global_transform.origin
	get_parent().add_child(inst)
