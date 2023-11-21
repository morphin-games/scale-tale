class_name CollectibleGem
extends Node3D

@export var gem_id : String = "gid"

var ipos : PackedScene = preload("res://scenes/particle_effects/gem_taken.tscn")

func _ready() -> void:
	if((Persistance.persistance_data as PersistanceData).taken_gems.has(gem_id)):
		$Mesh.set_surface_override_material(0, load("res://materials/m_gem_taken.tres"))


func _on_player_detect_area_3d_player_entered(player : SPPlayer3D) -> void:
	if(!(Persistance.persistance_data as PersistanceData).taken_gems.has(gem_id)):
		(Persistance.persistance_data as PersistanceData).taken_gems.append(gem_id)
		Persistance.save()
		
	var inst : GPUParticlesIPOS3D = ipos.instantiate()
	inst.global_transform = global_transform
	if((Persistance.persistance_data as PersistanceData).taken_gems.has(gem_id)):
		(inst as GPUParticlesIPOS3D).draw_pass_1.surface_set_material(0, load("res://materials/m_gem_taken.tres"))
	get_parent().add_child(inst)
	queue_free()
