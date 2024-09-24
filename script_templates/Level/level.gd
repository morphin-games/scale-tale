# meta-name: Level base template
# meta-description: Add your own variables and functions related to Level logic.
# meta-default: true
# meta-space-indent: 4

@icon("res://addons/equinox/level_manager_system/ilevel.svg")
class_name _CLASS_
extends Level

# Add references to nodes that will be used for the level's logic and level logic.
# Example:
#
# @export var _player_pawn : Pawn
#
# func get_player_pawn() -> Pawn:
#     return player_pawn
#
# func process(delta : float) -> void:
#     if(get_player_pawn().health <= 0):
#         get_tree().change_scene_to_file("res://game_over.tscn")

# Virtual function.
# Override to add your behaviour.
func ready() -> void:
	pass

func _process(delta: float) -> void:
	pass
	
#func _physics_process(delta: float) -> void:
#	pass
