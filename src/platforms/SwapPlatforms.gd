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
		
	collision_one.disabled = true
	mesh_one.visible = false
	collision_two.disabled = false
	mesh_two.visible = true
	await get_tree().create_timer(time_to_change).timeout
	collision_two.disabled = true
	mesh_two.visible = false
	collision_one.disabled = false
	mesh_one.visible = true
	
func _on_timer_to_swap_timeout() -> void:
	collision_one.disabled = true
	mesh_one.visible = false
	collision_two.disabled = false
	mesh_two.visible = true
	await get_tree().create_timer(time_to_change).timeout
	print("a")
	collision_two.disabled = true
	mesh_two.visible = false
	collision_one.disabled = false
	mesh_one.visible = true
