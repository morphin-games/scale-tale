@tool
extends EditorPlugin

func _enter_tree() -> void:
	add_autoload_singleton("LevelManager", "level_manager_system/level_manager.gd")

func _exit_tree() -> void:
	remove_autoload_singleton("LevelManager")
