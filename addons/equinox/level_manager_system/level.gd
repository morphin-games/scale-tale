@icon("ilevel.svg")
class_name Level
## Base class for all Level classes.
## To make a Level, insert the Level node as the root of a scene;
## then right-click the node, select "Extend script...", use the "Level base template".
## A Level must be used to wire nodes together and add logic, similar to Level Blueprints in Unreal Engine. 
extends Node

## Rules of the level.
## Inside your level you can interact with the GameMode to add (for example) match start/stop logic.
@export var game_mode : GameMode

## Virtual function.
## Override to add your behaviour.
func ready() -> void:
	pass
	
## Virtual function.
## Override to add your behaviour.
func process(delta : float) -> void:
	pass

func _enter_tree() -> void:
	if(LevelManager.level != null):
		push_warning("LevelManager.level is already set.")
		return
	LevelManager.level = self

func _ready() -> void:
	tree_exiting.connect(Callable(func() -> void:
		LevelManager.level = null
	))
	ready()
	if(game_mode != null):
		game_mode.level = self
		game_mode.ready()
	
func _process(delta: float) -> void:
	process(delta)
	if(game_mode != null):
		game_mode.process(delta)
