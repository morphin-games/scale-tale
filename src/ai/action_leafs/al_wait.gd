class_name ALWait
extends ActionLeaf

@export var seconds : float = 2.0

@onready var wait_begin : float = Time.get_unix_time_from_system()

func tick(actor: Node, blackboard: Blackboard) -> int:
	print("Time.get_unix_time_from_system() - wait_begin: ", Time.get_unix_time_from_system() - wait_begin)
	if(Time.get_unix_time_from_system() - wait_begin >= seconds):
		return SUCCESS
	else:
		return RUNNING
