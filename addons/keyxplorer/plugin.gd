@tool
extends EditorPlugin

func _enter_tree() -> void:
	add_autoload_singleton("Keyxplorer", "res://addons/keyxplorer/keyxplorer.gd")

func _exit_tree() -> void:
	remove_autoload_singleton("Keyxplorer")

func _has_main_screen() -> bool:
	return true
	
func _make_visible(visible: bool) -> void:
	pass
	
func _get_plugin_name() -> String:
	return "Keyxplorer"
	
func _get_plugin_icon() -> Texture2D:
	return load("res://addons/keyxplorer/ikeyxplorer.svg")
