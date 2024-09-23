@tool
class_name TerminalEdit
extends CodeEdit

enum CommandType {
	NO_COMMAND,
	OS_COMMAND,
	CUSTOM_COMMAND,
}

enum NewLineCommandPosition {
	NONE,
	BEGIN,
	END,
}

const COMMAND_DELIMITER : String = "$ "

var plugin : EditorPlugin

var _custom_commands : Dictionary
var _root : String = "res://"
var _path : String = ""
var _output : Array[String] = []
var _history : Array[String] = []
var _history_position : int = -1

func _ready() -> void:
	(syntax_highlighter as CodeHighlighter).clear_keyword_colors()
	text = get_terminal_path() + COMMAND_DELIMITER
	_register_default_commands()
	_register_user_commands()
	_highlight_os_commands()
	
	EditorInterface.get_resource_filesystem().filesystem_changed.connect(Callable(func() -> void:
		_custom_commands = {}
		_register_default_commands()
		_register_user_commands()
	))

func register(custom_command : CustomCommand) -> void:
	_custom_commands[custom_command.get_command_name()] = custom_command
	(_custom_commands[custom_command.get_command_name()] as CustomCommand)._setup(self)

func batch_register(_custom_commands : Array[CustomCommand]) -> void:
	for custom_command in _custom_commands:
		register(custom_command)

func set_terminal_path(path : String) -> void:
	var split_path : PackedStringArray = _path.split("/")
	var split_new_path : PackedStringArray = path.split("/")
	var split_index : int = 0
	for path_route in split_new_path:
		if(path_route == ".." and _path != ""):
			split_path[split_index] = ""
		else:
			split_path.append(path_route)
		split_index += 1
		
	var new_path : String = ""
	for path_route in split_path:
		if(path_route == ""): continue
		new_path += path_route + "/"
		
	if(DirAccess.dir_exists_absolute(ProjectSettings.globalize_path(new_path))):
		_path = new_path
	else:
		insert_text("\nGiven path \"" + new_path + "\" doesn't exist!\n", get_caret_line(0), get_line(get_caret_line(0)).length())
		_new_command_line()
		
func get_terminal_path() -> String:
	return _root + _path
	
func get_commands() -> Array[CustomCommand]:
	var commands : Array[CustomCommand]
	for command_key in _custom_commands.keys():
		commands.append(_custom_commands[command_key] as CustomCommand)
	return commands
	
func _register_default_commands() -> void:
	var default_command_paths : PackedStringArray = DirAccess.get_files_at("res://addons/terminal/default_commands")
	var default_commands : Array[CustomCommand]
	for default_command_path in default_command_paths:
		default_commands.append(load("res://addons/terminal/default_commands/" + default_command_path).new())
	batch_register(default_commands)
	
func _register_user_commands() -> void:
	var custom_command_paths : PackedStringArray = DirAccess.get_files_at("res://_terminal/user_commands")
	var custom_commands : Array[CustomCommand]
	for custom_command_path in custom_command_paths:
		var custom_command : Object = load("res://_terminal/user_commands/" + custom_command_path).new()
		if(!custom_command is CustomCommand): continue
		custom_commands.append(custom_command)
	batch_register(custom_commands)
	
func _highlight_os_commands() -> void:
	var os_name : String = OS.get_name()
	if(os_name == "Windows"):
		OS.execute("help", [], _output, true)
	elif(os_name == "Linux"):
		OS.execute("bash", ["-c", "compgen -c"], _output, false)
	for os_command in _output[0].split("\n"):
		(syntax_highlighter as CodeHighlighter).add_keyword_color(os_command, Color("#ffcaba"))
	
func _restricted_reached() -> bool:
	var caret_line : int = get_caret_line(0)
	var caret_col : int = get_caret_column(0)
	var root_line : bool = get_line(caret_line).split(COMMAND_DELIMITER)[0] == get_terminal_path()
	return root_line and caret_col <= (get_terminal_path() + COMMAND_DELIMITER).length()

func _get_command_type(line : String) -> CommandType:
	var line_split : PackedStringArray = line.split(get_terminal_path() + COMMAND_DELIMITER)
	if(line_split[1] == ""):
		return CommandType.NO_COMMAND
	elif(_custom_commands.keys().has(line_split[1].split(" ")[0])):
		return CommandType.CUSTOM_COMMAND
	else:
		return CommandType.OS_COMMAND
		
func _new_command_line(newline_position : NewLineCommandPosition = NewLineCommandPosition.BEGIN) -> void:
	var caret_line : int = get_caret_line(0)
	var new_line : String = get_terminal_path() + COMMAND_DELIMITER
	if(newline_position == NewLineCommandPosition.BEGIN):
		new_line = "\n" + new_line
	elif(newline_position == NewLineCommandPosition.END):
		new_line += "\n"
	insert_text(new_line, caret_line, get_line(caret_line).length())
	scroll_vertical = INF

func _historify_command(command : String) -> void:
	_history.push_front(command)
	if(_history.size() > 256):
		_history.pop_back()

func _execute_os(line : String) -> void:
	_output = []
	var line_split : PackedStringArray = line.split(get_terminal_path() + COMMAND_DELIMITER)
	if(line_split.size() == 1): return
	
	var full_command : String = line_split[1]
	var os_name : String = OS.get_name()
	if(os_name == "Windows"):
		OS.execute("CMD.exe", ["/C", "cd " + ProjectSettings.globalize_path(get_terminal_path()) + " && " + full_command], _output, true)
	elif(os_name == "Linux"):
		OS.execute("bash", ["-c", "cd " + ProjectSettings.globalize_path(get_terminal_path()) + " && " + full_command], _output, true)
	for result in _output:
		if(result == ""):
			continue
		insert_text("\n" + result, get_caret_line(0), get_line(get_caret_line(0)).length())
	var caret_line : int = get_caret_line(0)
	_historify_command(full_command)
	_new_command_line()

func _execute_custom(line : String) -> void:
	_output = []
	var line_split : PackedStringArray = line.split(get_terminal_path() + COMMAND_DELIMITER)
	if(line_split.size() == 1): return
	
	var full_command : String = line_split[1]
	var command_split : PackedStringArray = full_command.split(" ")
	var command : String = command_split[0]
	var args : Array[String]
	var custom_command : CustomCommand = (_custom_commands[command] as CustomCommand)
	for i in range(1, command_split.size()):
		args.append(command_split[i])
	_output = custom_command.action(args)
	for result in _output:
		if(result == "" or result == null):
			continue
		insert_text("\n" + result, get_caret_line(0), get_line(get_caret_line(0)).length())
	var caret_line : int = get_caret_line(0)
	_historify_command(full_command)
	_new_command_line(custom_command.get_newline_position())
	
# #############################
# Overrides
# #############################

func _backspace(caret_index: int) -> void:
	if(!_restricted_reached()):
		var caret_line : int = get_caret_line(0)
		var caret_col : int = get_caret_column(0)
		remove_text(caret_line, caret_col - 1, caret_line, caret_col)

func _input(event: InputEvent) -> void:
	if(!has_focus()): return
	
	if(event is InputEventKey):
		if(!event.is_pressed()): return
		if(event.keycode == KEY_ENTER):
			get_viewport().set_input_as_handled() # Override default \n
			if(get_caret_line(0) < get_line_count() - 1): return
			var line : String = get_line(get_caret_line(0))
			if(_get_command_type(line) == CommandType.OS_COMMAND):
				_execute_os(line)
			elif(_get_command_type(line) == CommandType.CUSTOM_COMMAND):
				_execute_custom(line)
			else:
				_new_command_line()
			_history_position = -1
			EditorInterface.get_resource_filesystem().scan()
		elif(event.keycode == KEY_TAB):
			get_viewport().set_input_as_handled()
			var line : String = get_line(get_caret_line(0))
			var line_split : PackedStringArray = line.split(get_terminal_path() + COMMAND_DELIMITER)
			if(line_split.size() == 1): return
			var command : String = line_split[1].split(" ")[0]
			if(!_custom_commands.has(command)): return
			var tab_autocomplete = (_custom_commands[command] as CustomCommand).get_tab_autocomplete()
			if(tab_autocomplete == ""): return
			insert_text("\n" + tab_autocomplete + "\n", get_caret_line(0), line.length())
			_new_command_line()
			insert_text(command, get_caret_line(0), get_caret_column(0))
		elif(event.keycode == KEY_LEFT and _restricted_reached()):
			get_viewport().set_input_as_handled()
		elif(event.keycode == KEY_UP or event.keycode == KEY_DOWN):
			if(event.keycode == KEY_UP):
				if(_history_position < _history.size() - 1 and _history.size() > 0):
					_history_position += 1
			elif(event.keycode == KEY_DOWN and _history.size() > 0):
				if(_history_position > 0):
					_history_position -= 1
			get_viewport().set_input_as_handled()
			set_caret_column((get_terminal_path() + COMMAND_DELIMITER).length())
			remove_line_at(get_line_count() - 1)
			if(get_line_count() <= 2):
				_new_command_line(NewLineCommandPosition.NONE)
			else:
				_new_command_line(NewLineCommandPosition.BEGIN)
			insert_text(_history[_history_position], get_line_count() - 1, get_caret_column(0))
		elif(get_caret_line(0) != get_line_count() - 1):
			get_viewport().set_input_as_handled()
	elif(event is InputEventMouseButton):
		if(event.button_index == MOUSE_BUTTON_LEFT):
			if(_restricted_reached()):
				set_caret_column((get_terminal_path() + COMMAND_DELIMITER).length())
