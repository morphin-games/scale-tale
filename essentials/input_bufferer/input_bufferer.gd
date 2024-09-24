@icon("iinput_manager.svg")
class_name InputBufferer
## Manage inputs with a buffer to add a little margin of error in the detection of inputs and prevent input loss.
extends Node

## The maximum number of frames before discarding an input.
@export var frame_buffer_limit : int = 6

var _input_buffers : Dictionary

## Add an Input to the buffer.
## If the input's [param condition] is met, the [param action] is called.
## [param condition] must be a Callable that returns a boolean.
func buffer(input : String, action : Callable, condition : Callable) -> void:
	_input_buffers[input] = InputBuffer.new(Engine.get_process_frames(), input, action, condition)

func _process(delta: float) -> void:
	for key in _input_buffers.keys():
		var input_buffer : InputBuffer = _input_buffers[key]
		if(input_buffer.frame + frame_buffer_limit < Engine.get_process_frames()):
			_input_buffers.erase(key)
			continue
		if(input_buffer.condition.call() == true):
			input_buffer.action.call()
			_input_buffers.erase(key)
