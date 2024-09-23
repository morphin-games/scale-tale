class_name CustomCommandMkcom
extends CustomCommand

# Virtual function.
# Override to set your command name when calling it through the terminal.
func get_command_name() -> String:
	return "mkcom" # res://$ CustomCommandMkcom <- Your command

# Virtual function.
# Override to add your command name.
func get_command_description() -> String:
	return "Creates a new CustomCommand."
	
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
		return ["You must provide a name!\n"]
	var name : String = args[0]
	var custom_command : GDScript = GDScript.new()
	var source_code : String = (load("res://script_templates/CustomCommand/custom_command.gd") as GDScript).source_code
	var source_code_split : PackedStringArray = source_code.split("\n")
	var lines_replaced : int = 0
	var source_after_replace : String = ""
	for line in source_code_split:
		if(line.contains("_CLASS_")):
			if(lines_replaced == 0):
				line = line.replace("_CLASS_", "CustomCommand" + name.to_pascal_case())
			else:
				line = line.replace("_CLASS_", name.to_lower())
			lines_replaced += 1
		source_after_replace += line + "\n"
	custom_command.source_code = source_after_replace
	if(args.has("-p") or args.has("--plugin")):
		ResourceSaver.save(custom_command, "res://addons/terminal/default_commands/custom_command_" + name.to_snake_case() + ".gd")
		var command : GDScript = load("res://addons/terminal/default_commands/custom_command_" + name.to_snake_case() + ".gd")
		EditorInterface.edit_script(command)
	else:
		ResourceSaver.save(custom_command, "res://_terminal/user_commands/" + name.to_snake_case() + ".gd")
		var command : GDScript = load("res://_terminal/user_commands/" + name.to_snake_case() + ".gd")
		EditorInterface.edit_script(command)
	return []
