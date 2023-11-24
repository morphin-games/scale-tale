class_name Scalable3D
extends Node

signal scale_changed(current_scale : Vector3)

@export var root : Node3D
@export var unaffected_items : Array[Node3D]
@export var scale_speed : float = 1
@export_group("Scale limits")
@export var min_scale : float = 0.5
@export var max_scale : float = 4.0

@onready var current_scale : Vector3 = root.scale
@onready var particles_scene : PackedScene = load("res://scenes/particle_effects/scale_particles.tscn")

var affected_children : Array[Node]
var particles : ScaleParticles

func _ready() -> void:
	affected_children = root.get_children()
	for u_it in unaffected_items:
		for child in affected_children:
			if(child == u_it):
				affected_children.erase(child)
				
	await get_tree().create_timer(1.0).timeout
	particles = particles_scene.instantiate()
	root.add_child(particles)
	particles.global_transform.origin = root.global_transform.origin
	var scalable_colls : Array[Node] = Utils.find_custom_nodes(root, "res://scripts/classes/collision_shape_scalable_3d.gd")
	if(scalable_colls.size() > 0):
		print("LLOOOOLL")
		particles.set_shape((scalable_colls[0] as CollisionShapeScalable3D).shape)
		
func downscale(delta : float) -> void:
#	particles.emit(true)
	current_scale += Vector3(scale_speed, scale_speed, scale_speed) * delta
	current_scale = current_scale.clamp(Vector3(min_scale, min_scale, min_scale), Vector3(max_scale, max_scale, max_scale))
	emit_signal("scale_changed", current_scale)
	await(get_tree().create_timer(0.1))
	particles.set_size(current_scale.x)
#	particles.emit(false)
	
func upscale(delta : float) -> void:
#	particles.emit(true)
	current_scale -= Vector3(scale_speed, scale_speed, scale_speed) * delta
	current_scale = current_scale.clamp(Vector3(min_scale, min_scale, min_scale), Vector3(max_scale, max_scale, max_scale))
	emit_signal("scale_changed", current_scale)
	await(get_tree().create_timer(0.1))
	particles.set_size(current_scale.x)
#	particles.emit(false)
		
func _process(delta: float) -> void:
	for child in affected_children:
		if(child != null):
			if(child is Node3D):
				child.scale = current_scale
