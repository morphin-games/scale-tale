class_name EnemyAnimationController
extends Node

@export var enemy : EnemyBody3D
@export var animation : AnimationPlayer
@export var animation_tree : AnimationTree

var idle_or_run : float = 0.0

func _process(delta: float) -> void:
	if(!enemy.alive):
		animation_tree.active = false
		animation.stop(false)
	
	if(enemy.status == enemy.EnemyStatus.FOLLOWING or enemy.status == enemy.EnemyStatus.PATROLING):
		idle_or_run = move_toward(idle_or_run, 1.0, 0.1)
	else:
		idle_or_run = move_toward(idle_or_run, 0.0, 0.1)
		
	animation_tree.set("parameters/idle_or_run/blend_amount", idle_or_run)
		
