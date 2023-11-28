class_name Stompable3D
extends Node3D

signal stomped

@export var enemy : EnemyBody3D
@export var player_detector : PlayerDetectArea3D
@export var death_impulse : float = 9.0
@export_category("Scale")
@export var scalable : Scalable3D
@export var vulnerable_scale : Vector3 = Vector3(0.5, 0.5, 0.5)
@export_category("Vulnerabilities")
@export var vulnerable_radius : float = 1.0
@export_category("Audio")
@export var killed_sfx : AudioStreamPlayer3D
@export var bounce_sfx : AudioStreamPlayer3D

var player : SPPlayer3D
var explosion : PackedScene = preload("res://scenes/particle_effects/smoke.tscn")

func stomp() -> void:
#	if(player.near_bodies.has(enemy)):
#		player.near_bodies.erase(enemy)
	
	killed_sfx.play()
	enemy.alive = false
	enemy.collision_shape.queue_free()
	enemy.stun(100.0)
	enemy.velocity.y = 0.0
	var tween_s : Tween = get_tree().create_tween()
	tween_s.tween_property(enemy.get_node("Mesh").get_child(0), "scale", Vector3(enemy.get_node("Mesh").get_child(0).scale.x, 0.03, enemy.get_node("Mesh").get_child(0).scale.z), 0.23)
	
	tween_s.finished.connect(Callable(func() -> void:
		await get_tree().create_timer(0.5).timeout
		var inst : GPUParticlesIPOS3D = explosion.instantiate()
		enemy.get_parent().add_child(inst)
		inst.global_transform.origin = global_transform.origin
		enemy.queue_free()
	))

func _ready() -> void:
	player_detector.player_entered.connect(Callable(func(player : SPPlayer3D) -> void:
		self.player = player
		if(player.global_transform.origin.y > global_transform.origin.y):
#		and Utils.between(player.global_transform.origin.x, global_transform.origin.x - (vulnerable_radius / 2), global_transform.origin.x + (vulnerable_radius / 2))
#		and Utils.between(player.global_transform.origin.z, global_transform.origin.z - (vulnerable_radius / 2), global_transform.origin.z + (vulnerable_radius / 2))
			if(!enemy.alive) : return
			if(scalable == null or (scalable != null and scalable.current_scale.x <= vulnerable_scale.x)):
				player.velocity.y = death_impulse
				player.move_and_slide()
				
				stomp()
			else:
				bounce_sfx.play()
				var force : Vector3 = (enemy.global_transform.origin - player.global_transform.origin).normalized()
				player.velocity.y = death_impulse * 2
				player.move_and_slide()
				player.jump_external_force = Vector2(force.x, force.z) * 2
				enemy.stun(0.5)
		
		else:
			if(!enemy.alive) : return
			enemy.velocity.y = 3.0
			enemy.move_and_slide()
			enemy.stun()
			
#			var force : Vector3 = (enemy.global_transform.origin - player.global_transform.origin).normalized()
#			var force : Vector3 = enemy.get_node("WatchPlayer").target_position.normalized()
			var force : Vector2 = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
			player.velocity.y = death_impulse * 1.8
			player.move_and_slide()
			player.jump_external_force = force * 4.0
			player.health_system.damage(1)
	))
