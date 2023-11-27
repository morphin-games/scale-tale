class_name PlayerDetectArea3D
extends Area3D

signal player_entered(player : SPPlayer3D)
signal player_exited(player : SPPlayer3D)

func _ready() -> void:
	body_entered.connect(Callable(func(body : PhysicsBody3D) -> void:
		if(body.name == "Player"):
			emit_signal("player_entered", (body as SPPlayer3D))
	))
	
	body_exited.connect(Callable(func(body : PhysicsBody3D) -> void:
		if(body.name == "Player"):
			emit_signal("player_exited", (body as SPPlayer3D))
	))

