class_name CustomCommandComls
extends CustomCommand

# Virtual function.
# Override to set your command name when calling it through the terminal.
func get_command_name() -> String:
	return "comls" # res://$ custom_command_comls <- Your command

# Virtual function.
# Override to add your command name.
func get_command_description() -> String:
	return "Lists all the available commands."
	
# Virtual function.
# Override to add autocomplete options when writting your command in the terminal.
func get_tab_autocomplete() -> String:
	return "" # Leave as an empty string if the command has no autocomplete.

# Virtual function.
# Override to determine the position of your new line (\n).
# If there's a new line after your command execution, try swapping between BEGIN and END.
func get_newline_position() -> TerminalEdit.NewLineCommandPosition:
	return TerminalEdit.NewLineCommandPosition.NONE

func _get_spaces(command_name : String) -> String:
	var spaces : int = 10
	spaces -= command_name.length()
	var spaces_string = ""
	for space in spaces:
		spaces_string += " "
	return spaces_string

# Virtual function.
# Override to add your command functionality.
# Returned result will shown in the terminal.
func action(args : Array[String] = []) -> Array[String]:
	var output : Array[CustomCommand] = _terminal.get_commands()
	var commands : Array[String]
	for command in output:
		commands.append("- " + command.get_command_name() + _get_spaces(command.get_command_name()) + "| " + command.get_command_description())
	commands.push_front("Command list (" + str(commands.size()) + "):")
	commands.push_back("\n")
	return commands
