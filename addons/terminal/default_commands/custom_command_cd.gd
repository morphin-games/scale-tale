class_name CustomCommandCd
extends CustomCommand

# Virtual function.
# Override to set your command name when calling it through the terminal.
func get_command_name() -> String:
	return "cd" # res://$ CustomCommandLs <- Your command

# Virtual function.
# Override to add your command name.
func get_command_description() -> String:
	return "Changes directory of the terminal."
	
# Virtual function.
# Override to add autocomplete options when writting your command in the terminal.
func get_tab_autocomplete() -> String:
	var paths : String = ""
	var dirs : PackedStringArray = DirAccess.get_directories_at(ProjectSettings.globalize_path(_terminal.get_terminal_path()))
	var line : String = _terminal.get_line(_terminal.get_caret_line(0))
	var line_split : PackedStringArray = line.split(_terminal.get_terminal_path() + _terminal.COMMAND_DELIMITER)
	var command_split : PackedStringArray = line_split[1].split(" ")
	
	print(command_split)
	
	if(command_split.size() == 1 or (command_split.size() == 2 and command_split[1] == "")):
		for i in range(0, dirs.size()):
			paths += dirs[i]
			if(i < dirs.size() - 1):
				paths += "\n"
		return paths
	elif(command_split.size() == 2):
		var arg : String = command_split[1]
		for dir in dirs:
			if(dir.left(arg.length()) != arg): continue
			var missing_chars : String = dir.substr(arg.length(), dir.length())
			_terminal.insert_text(missing_chars, _terminal.get_caret_line(0), _terminal.get_caret_column(0))
			break
		return ""
	else:
		return ""

# Virtual function.
# Override to determine the position of your new line (\n).
# If there's a new line after your command execution, try swapping between BEGIN and END.
func get_newline_position() -> TerminalEdit.NewLineCommandPosition:
	return TerminalEdit.NewLineCommandPosition.BEGIN

# Virtual function.
# Override to add your command functionality.
# Returned result will shown in the terminal.
func action(args : Array[String] = []) -> Array[String]:
	_terminal.set_terminal_path(args[0])
	return [] # Must always be an array. If you don't want an output, leave empty.
