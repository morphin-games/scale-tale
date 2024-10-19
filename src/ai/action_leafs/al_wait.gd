class_name ALWait
extends ActionLeaf

@export var seconds : float = 2.0

func tick(actor: Node, blackboard: Blackboard) -> int:
	if(Time.get_unix_time_from_system() - blackboard.get_value("wait_time_start") >= seconds):
		return SUCCESS
	else:
		return RUNNING
