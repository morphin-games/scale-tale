# meta-name: GameMode base template
# meta-description: Add your own variables, functions and signals related to GameMode.
# meta-default: true
# meta-space-indent: 4

@icon("res://addons/equinox/level_manager_system/ilevel_rules.svg")
class_name _CLASS_
extends GameMode

# Add variables, signals and functions that will be used to create match logic.
#
# Example:
#
# @export var team_a_color : String = "red"
# @export var team_b_color : String = "blue"
#
# var team_a_goals : int = 0
# var team_b_goals : int = 0
# var team_a_players : int = 0
# var team_b_players : int = 0
#
# func add_team_player(player : TeamController) -> void:
# 	if(team_a_players >= team_b_players):
#		team_b_players += 1
#		player.team_color = team_b_color
#	else:
#		team_a_players += 1
#		player.team_color = team_a_color
#
# With these variables and functions you could make a football Level.

# Virtual function.
# Override with your own behaviour
func ready() -> void:
	pass
	
# Virtual function.
# Override with your own behaviour
func process(delta : float) -> void:
	pass

# Virtual function.
# Override with your own reset behaviour
func reset() -> void:
	# team_a_goals = 0
	# team_b_goals = 0
	pass
