## Simple singleton to get a reference to the current active level.
extends Node

signal level_changed

var level : Level :
	get:
		return level
	set(new_level):
		level = new_level
		level_changed.emit()
