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

var affected_children : Array[Node]
		
func _ready() -> void:
	affected_children = root.get_children()
	for u_it in unaffected_items:
		for child in affected_children:
			if(child == u_it):
				affected_children.erase(child)
		
func downscale(delta : float) -> void:
	current_scale += Vector3(scale_speed, scale_speed, scale_speed) * delta
	current_scale = current_scale.clamp(Vector3(min_scale, min_scale, min_scale), Vector3(max_scale, max_scale, max_scale))
	emit_signal("scale_changed", current_scale)
	
func upscale(delta : float) -> void:
	current_scale -= Vector3(scale_speed, scale_speed, scale_speed) * delta
	current_scale = current_scale.clamp(Vector3(min_scale, min_scale, min_scale), Vector3(max_scale, max_scale, max_scale))
	emit_signal("scale_changed", current_scale)
		
func _process(delta: float) -> void:
	for child in affected_children:
		if(child is Node3D):
			child.scale = current_scale
