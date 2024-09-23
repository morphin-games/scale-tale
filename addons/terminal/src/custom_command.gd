class_name CustomCommand
extends Resource

var _terminal : TerminalEdit

func _setup(terminal : TerminalEdit) -> void:
	_terminal = terminal
	(_terminal.syntax_highlighter as CodeHighlighter).add_keyword_color(get_command_name(), Color("#9ce8ff"))

## Virtual function.
## Override to add your command name.
func get_command_name() -> String:
	return "CustomCommand"
	
## Virtual function.
## Override to add your command name.
func get_command_description() -> String:
	return "Description"
	
## Virtual function.
## Override to add autocomplete options when writting your command in the terminal.
func get_tab_autocomplete() -> String:
	return "" # Leave as an empty string of the command has no autocomplete.

## Virtual function.
## Override to determine the position of your new line (\n).
## If there's a new line after your command execution, try swapping between BEGIN and END.
func get_newline_position() -> TerminalEdit.NewLineCommandPosition:
	return TerminalEdit.NewLineCommandPosition.BEGIN

## Virtual function.
## Override to add your command name.
## Returned result will shown in the terminal.
func action(args : Array[String] = []) -> Array[String]:
	return [] # Must always be an array. If you don't want an output, leave empty.
