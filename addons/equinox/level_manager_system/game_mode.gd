@icon("igame_mode.svg")
class_name GameMode
extends Resource

signal max_players_reached
signal min_players_reached
signal max_players_unreached
signal min_players_unreached
signal max_duration_reached

## Minimum amount of players in a game mode.
## Can be used inside the game mode to add start/stop logic.
@export_range(1, 128) var min_players : int = 1
## Maximum amount of players in a game mode.
## Can be used inside the game mode to add start/stop logic.
@export_range(1, 128) var max_players : int = 1
## Maximum duration in seconds of a game mode.
## Can be used inside the game mode to add start/stop logic.
@export var max_duration : float = INF

## Reference to the Level.
var level : Level
## Internal counter of total players in a game mode.
## Can be used inside the game mode to add start/stop logic.
var players : int = 0
## Internal counter of total duration of a game mode.
## Can be used inside the game mode to add start/stop logic.
var duration : float = 0.0

## Adds a player to the player counter.
func add_player() -> void:
	if(players == max_players): return
	players += 1
	if(players == min_players):
		min_players_reached.emit()
	if(players == max_players):
		max_players_reached.emit()

## Removes a player from the player counter.
func remove_player() -> void:
	if(players == 0): return
	players -= 1
	if(players == min_players - 1):
		min_players_unreached.emit()
	if(players == max_players - 1):
		max_players_unreached.emit()

## Virtual function.
## Override with your own behaviour.
func ready() -> void:
	pass
	
## Virtual function.
## Override with your own behaviour.
func process(delta : float) -> void:
	pass
	
## Virtual function.
## Override with your own reset behaviour.
func reset() -> void:
	pass
	
# Do not override this function.
# This is the default class behaviour.
# To add custom behaviour, override [method process]
func _default_process(delta : float) -> void:
	if(duration < max_duration and max_duration != INF):
		duration += delta
		if(duration >= max_duration):
			max_duration_reached.emit()
