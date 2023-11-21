class_name CollectibleCoin
extends Node3D

var ipos : PackedScene = preload("res://scenes/particle_effects/coin_taken.tscn")

func _on_player_detect_area_3d_player_entered(player : SPPlayer3D) -> void:
	(Persistance.persistance_data as PersistanceData).coin_recount += 1
	Persistance.save()
	var inst : GPUParticlesIPOS3D = ipos.instantiate()
	inst.global_transform = global_transform
	get_parent().add_child(inst)
	queue_free()
