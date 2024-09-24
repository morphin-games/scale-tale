class_name CustomCommandPlugren
extends CustomCommand

# Virtual function.
# Override to set your command name when calling it through the terminal.
func get_command_name() -> String:
	return "plugren" # res://$ CustomCommandPlugren <- Your command

# Virtual function.
# Override to add your command name.
func get_command_description() -> String:
	return "Reenables the given plugin."
	
# Virtual function.
# Override to add autocomplete options when writting your command in the terminal.
func get_tab_autocomplete() -> String:
	return "" # Leave as an empty string if the command has no autocomplete.

# Virtual function.
# Override to determine the position of your new line (\n).
# If there's a new line after your command execution, try swapping between BEGIN and END.
func get_newline_position() -> TerminalEdit.NewLineCommandPosition:
	return TerminalEdit.NewLineCommandPosition.BEGIN

# Virtual function.
# Override to add your command functionality.
# Returned result will shown in the terminal.
func action(args : Array[String] = []) -> Array[String]:
	if(args.size() == 0): 
		return [
			"A plugin name must be passed!\n",
		]
	elif(args.size() > 1):
		return [
			"Only the plugin name must be passed (no spaces allowed)!\n",
		]
	elif(args.size() == 1):
		EditorInterface.set_plugin_enabled(args[0], false)
		EditorInterface.set_plugin_enabled(args[0], true)
		return []
	else:
		return []
