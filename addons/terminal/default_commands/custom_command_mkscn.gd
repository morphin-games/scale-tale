class_name CustomCommandMkscn
extends CustomCommand

# Virtual function.
# Override to set your command name when calling it through the terminal.
func get_command_name() -> String:
	return "mkscn" # res://$ CustomCommandMkscn <- Your command

# Virtual function.
# Override to add your command name.
func get_command_description() -> String:
	return "Creates a new .scn Resource."
	
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
			"-n / --name : Name of the scene",
			"-p / --path : Save path of the scene, can be either relative or full. If no path is given, the scene is saved to the current directory of the terminal.\n",
		]
		
	var name : String = ArgGetter.get_arg(["-n", "--name"], args)
	var path : String = ArgGetter.get_arg(["-p", "--path"], args)
	if(name == ""):
		return [
			"Name argument missing! (-n / --name)\n",
		]
	var scene : PackedScene = PackedScene.new()
	var root : Node = Node.new()
	root.name = name.to_pascal_case()
	scene.pack(root)
	if(path.left(6) == "res://"):
		ResourceSaver.save(scene, path + name.to_snake_case() + ".scn")
		EditorInterface.open_scene_from_path(path + name.to_snake_case() + ".scn")
	else:
		ResourceSaver.save(scene, _terminal.get_terminal_path() + name.to_snake_case() + ".scn")
		EditorInterface.open_scene_from_path(_terminal.get_terminal_path() + name.to_snake_case() + ".scn")
	return [] # Must always be an array. If you don't want an output, leave empty.
