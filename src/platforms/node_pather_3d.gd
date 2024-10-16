class_name NodePather3D
extends Path3D

@export var active : bool = true
@export_range(0.01, 100.0) var progression_rate : float = 1.5

@onready var target : Node3D = get_parent() as Node3D
@onready var path_follow_3d : PathFollow3D = PathFollow3D.new() as PathFollow3D
@onready var base_position : Vector3 = global_transform.origin

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	path_follow_3d.loop = true
	add_child(path_follow_3d)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(!active): return
	
	path_follow_3d.progress += delta * progression_rate
	global_transform.origin = base_position
	target.global_transform.origin = path_follow_3d.global_transform.origin
