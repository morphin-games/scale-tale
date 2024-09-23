class_name InputBuffer
extends Resource

@export var frame : int
@export var input : String
@export var action : Callable
@export var condition : Callable

func _init(frame : int, input : String, action : Callable, condition : Callable) -> void:
	self.frame = frame
	self.input = input
	self.action = action
	self.condition = condition
