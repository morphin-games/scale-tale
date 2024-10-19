class_name PistonSpikes extends Node

@export var time_to_change : float = 3.0
@onready var timer_to_swap : Timer = $timer_to_swap
@onready var hurtbox : Hurtbox3D = $Hurtbox3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer_to_swap.wait_time = time_to_change * 2
	timer_to_swap.autostart = true
	timer_to_swap.start()
	await get_tree().create_timer(time_to_change).timeout
	hurtbox.set_collision_layer_value(3,false)
	hurtbox.set_collision_mask_value(1,false)
	hurtbox.visible = false

func _on_timer_to_swap_timeout() -> void:
	hurtbox.set_collision_layer_value(3,true)
	hurtbox.set_collision_mask_value(1,true)
	hurtbox.visible = true
	await get_tree().create_timer(time_to_change).timeout
	hurtbox.set_collision_layer_value(3,false)
	hurtbox.set_collision_mask_value(1,false)
	hurtbox.visible = false
