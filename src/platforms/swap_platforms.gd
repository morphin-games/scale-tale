extends Node3D
@export var time_to_change : float = 3.0

@onready var collision_one : CollisionShape3D = $platform1/CollisionShape3D
@onready var mesh_one: MeshInstance3D = $platform1/MeshInstance3D

@onready var collision_two : CollisionShape3D =$platform2/CollisionShape3D 
@onready var mesh_two: MeshInstance3D = $platform2/MeshInstance3D
@onready var timer_to_swap: Timer  = $timer_to_swap

var platforms_array = []
var swap_platforms = false


func _ready() -> void:
	for child in get_children():
		if child is PhysicsBody3D:
			platforms_array.append(child)

	timer_to_swap.wait_time = time_to_change * 2
	timer_to_swap.autostart = true
	timer_to_swap.start()
	await get_tree().create_timer(time_to_change).timeout
	platforms_array[0].set_collision_layer_value(2,false)
	platforms_array[0].visible = false
	platforms_array[1].set_collision_layer_value(2,true)
	platforms_array[1].visible = true

func _on_timer_to_swap_timeout() -> void:
	platforms_array[1].set_collision_layer_value(2,false)
	platforms_array[1].visible = false
	platforms_array[0].set_collision_layer_value(2,true)
	platforms_array[0].visible = true
	await get_tree().create_timer(time_to_change).timeout
	platforms_array[0].set_collision_layer_value(2,false)
	platforms_array[0].visible = false
	platforms_array[1].set_collision_layer_value(2,true)
	platforms_array[1].visible = true
