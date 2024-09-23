class_name CustomCommandRun
extends CustomCommand

# Virtual function.
# Override to set your command name when calling it through the terminal.
func get_command_name() -> String:
	return "run" # res://$ CustomCommandRun <- Your command

# Virtual function.
# Override to add your command name.
func get_command_description() -> String:
	return "Runs the given scene."
	
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
	if(args.has("-h") or args.has("--help")):
		return [
			"run                 : Run the default scene.",
			"run -c              : Run the current scene.",
			"run [relative_path] : Run the given scene from a path relative to the current terminal directory.",
			"run res://[path]    : Run the given scene from a full path using res://.\n",
		]
	elif(args.has("-c") or args.has("--current")):
		EditorInterface.play_current_scene()
	elif(args.size() == 1):
		if(args[0].left(6) == "res://"):
			EditorInterface.play_custom_scene(args[0])
		else:
			EditorInterface.play_custom_scene(_terminal.get_terminal_path() + args[0])
	else:
		EditorInterface.play_main_scene()
	return [] # Must always be an array. If you don't want an output, leave empty.
