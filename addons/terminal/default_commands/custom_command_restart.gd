class_name CustomCommandRestart
extends CustomCommand

# Virtual function.
# Override to set your command name when calling it through the terminal.
func get_command_name() -> String:
	return "restart" # res://$ CustomCommandClear <- Your command

# Virtual function.
# Override to add your command name.
func get_command_description() -> String:
	return "Restarts the editor."
	
# Virtual function.
# Override to add autocomplete options when writting your command in the terminal.
func get_tab_autocomplete() -> String:
	return "" # Leave as an empty string if the command has no autocomplete.

# Virtual function.
# Override to determine the position of your new line (\n).
# If there's a new line after your command execution, try swapping between BEGIN and END.
func get_newline_position() -> TerminalEdit.NewLineCommandPosition:
	return TerminalEdit.NewLineCommandPosition.END

# Virtual function.
# Override to add your command functionality.
# Returned result will shown in the terminal.
func action(args : Array[String] = []) -> Array[String]:
	EditorInterface.restart_editor()
	return [] # Must always be an array. If you don't want an output, leave empty.
