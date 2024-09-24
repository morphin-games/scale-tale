class_name LavaArea3D
extends Area3D

signal player_entered(player : SPPlayer3D)
signal player_exited(player : SPPlayer3D)

@export var damage : int = 1

var player : SPPlayer3D
var time_since_damage : float = 0.0

func _ready() -> void:
	body_entered.connect(Callable(func(body : PhysicsBody3D) -> void:
		if(body.name == "Player"):
			player = body
	))
	
	body_exited.connect(Callable(func(body : PhysicsBody3D) -> void:
		if(body.name == "Player"):
			player = null
	))
	
func _process(delta: float) -> void:
	if(player == null):
		time_since_damage = 3.0
		return
	else:
		time_since_damage += delta
		
	player.velocity.y = 15.0
	player.move_and_slide()
		
	if(time_since_damage >= 3.0):
		time_since_damage = 0.0
		(player as SPPlayer3D).health_system.damage(damage)
