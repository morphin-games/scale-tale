class_name CustomCommandMkcls
extends CustomCommand

# Virtual function.
# Override to set your command name when calling it through the terminal.
func get_command_name() -> String:
	return "mkcls" # res://$ mkcls <- Your command

# Virtual function.
# Override to add your command name.
func get_command_description() -> String:
	return "Creates a new Script with a preconfigured \"class_name\" and \"extends\"."

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
			"-n / --name    : Name of the class",
			"-p / --path    : Save path of the class, can be either relative or full. If no path is given, the class is saved to the current directory of the terminal.\n",
			"-e / --extends : Base class to extend from, must be in PascalCase.\n",
		]
		
	var name : String = ArgGetter.get_arg(["-n", "--name"], args)
	var path : String = ArgGetter.get_arg(["-p", "--path"], args)
	var extend : String = ArgGetter.get_arg(["-e", "--extends"], args)
	if(name == ""):
		return [
			"Name argument missing! (-n / --name)\n",
		]
	elif(extend == ""):
		return [
			"Extends argument missing! (-e / --extends)\n",
		]
	var script : GDScript = GDScript.new()
	script.source_code = "class_name " + name.to_pascal_case() + "\nextends " + extend + "\n\nfunc _ready() -> void:\n	pass\n\nfunc _process(delta : float) -> void:\n	pass\n"
	if(path.left(6) == "res://"):
		ResourceSaver.save(script, path + name.to_snake_case() + ".gd")
		EditorInterface.edit_script(load(path + name.to_snake_case() + ".gd"))
	else:
		ResourceSaver.save(script, _terminal.get_terminal_path() + name.to_snake_case() + ".gd")
		EditorInterface.edit_script(load(_terminal.get_terminal_path() + name.to_snake_case() + ".gd"))
	return [] # Must always be an array. If you don't want an output, leave empty.
