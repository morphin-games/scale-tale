class_name ALSetWaitTimeStart
extends ActionLeaf

@export var time : float = 2.0

func tick(actor: Node, blackboard: Blackboard) -> int:
	blackboard.set_value("wait_time_start", Time.get_unix_time_from_system())
	return SUCCESS
