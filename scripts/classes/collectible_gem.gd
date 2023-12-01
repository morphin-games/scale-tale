class_name CollectibleGem
extends Node3D

@export var gem_id : String = "gid"

var ipos : PackedScene = preload("res://scenes/particle_effects/coin_taken.tscn")

func _ready() -> void:
	if((Persistance.persistance_data as PersistanceData).taken_gems.has(gem_id)):
		$Node3D/Mesh.set_surface_override_material(0, load("res://materials/m_gem_taken.tres"))
		$Node3D/Mesh2.set_surface_override_material(0, load("res://materials/m_gem_taken.tres"))


func _on_player_detect_area_3d_player_entered(player : SPPlayer3D) -> void:
	var inst : GPUParticlesIPOS3D = ipos.instantiate()
	get_parent().add_child(inst)
	inst.global_transform = global_transform
	if((Persistance.persistance_data as PersistanceData).taken_gems.has(gem_id)):
		(inst as GPUParticlesIPOS3D).draw_pass_1.surface_set_material(0, load("res://materials/m_gem_taken.tres"))
	
	if(!(Persistance.persistance_data as PersistanceData).taken_gems.has(gem_id)):
		(Persistance.persistance_data as PersistanceData).taken_gems.append(gem_id)
		player.get_gem()
		Persistance.save()
		await player.gem_taken_animation_finished
		if((Persistance.persistance_data as PersistanceData).taken_gems.size() >= 5):
			player.credits()
		
	var data : AudioStream3DData = AudioStream3DData.new()
	Utils.play_3d_sound_at(load("res://art/sfx/pick_up_sfx/gema.mp3"), global_transform.origin, get_parent(), data)
	
	queue_free()
