@icon("res://addons/equinox/level_manager_system/ilevel.svg")
class_name LevelBase
extends Level

@export var navigation_region : NavigationRegion3D

var player_pawn : PlayerPawn

# Virtual function.
# Override to add your behaviour.
func ready() -> void:
	pass

func _process(delta: float) -> void:
	pass
	
#func _physics_process(delta: float) -> void:
#	pass
