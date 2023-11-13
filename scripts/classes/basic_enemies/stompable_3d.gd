class_name Stompable3D
extends Node3D

@export var enemy : EnemyBody3D
@export var player_detector : PlayerDetectArea3D
@export var death_impulse : float = 8.0
@export_category("Vulnerabilities")
@export var vulnerable_radius : float = 1.0

func _ready() -> void:
	player_detector.player_entered.connect(Callable(func(player : SPPlayer3D) -> void:
		if(player.global_transform.origin.y > global_transform.origin.y 
		and Utils.between(player.global_transform.origin.x, global_transform.origin.x - (vulnerable_radius / 2), global_transform.origin.x + (vulnerable_radius / 2))
		and Utils.between(player.global_transform.origin.z, global_transform.origin.z - (vulnerable_radius / 2), global_transform.origin.z + (vulnerable_radius / 2))):
			player.velocity.y = death_impulse
			enemy.queue_free()
		else:
			print("OOF")
	))
