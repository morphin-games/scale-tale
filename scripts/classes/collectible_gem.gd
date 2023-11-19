class_name CollectibleGem
extends Node3D

@export var player_detector : PlayerDetectArea3D
@export var gem_id : String = "gid"

func _ready() -> void:
	if((Persistance.persistance_data as PersistanceData).taken_gems.has(gem_id)):
		$Mesh.set_surface_override_material(0, load("res://materials/m_gem_taken.tres"))
	
	player_detector.player_entered.connect(Callable(func(player : SPPlayer3D) -> void:
		if(!(Persistance.persistance_data as PersistanceData).taken_gems.has(gem_id)):
			(Persistance.persistance_data as PersistanceData).taken_gems.append(gem_id)
			Persistance.save()
		queue_free()
	))
