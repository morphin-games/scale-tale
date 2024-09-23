@tool
extends EditorPlugin

var terminal_ui : Control = load("res://addons/terminal/ui/terminal.tscn").instantiate()

func _enter_tree() -> void:
	add_control_to_bottom_panel(terminal_ui, "Terminal")
	terminal_ui.setup(self)
	if(!DirAccess.dir_exists_absolute("res://_terminal")):
		DirAccess.make_dir_absolute("res://_terminal")
	if(!DirAccess.dir_exists_absolute("res://_terminal/user_commands")):
		DirAccess.make_dir_absolute("res://_terminal/user_commands")
	EditorInterface.get_resource_filesystem().scan()
	
func _exit_tree() -> void:
	remove_control_from_bottom_panel(terminal_ui)
