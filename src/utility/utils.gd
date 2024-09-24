class_name Utils
extends Node

static func find_children_of_class(root : Node, find_class : String, recursive : bool = false) -> Array[Node]:
	if(root == null): return []
	var nodes : Array[Node] = []
	for node in root.get_children(recursive):
		if(node.get_class() == find_class):
			nodes.append(node)
		
	return nodes

static func find_custom_nodes(root : Node, find_class : String, recursive : bool = false) -> Array[Node]:
	if(root == null): return []
	var nodes : Array[Node] = []
	for node in root.get_children(recursive):
		if(node.get_script() == load(find_class)):
			nodes.append(node)
		
	return nodes
	
static func find_multiple_custom_nodes(root : Node, find_classes : Array[String], recursive : bool = false) -> Array[Node]:
	if(root == null): return []
	var nodes : Array[Node] = []
	for node in root.get_children(recursive):
		for j in range(0, find_classes.size()):
			if(node.get_script() == load(find_classes[j])):
				nodes.append(node)
		
	return nodes
	
static func now() -> int:
	return Time.get_unix_time_from_system()
	
static func between(checked : float, min : float, max : float) -> bool:
	return(checked >= min and checked <= max)
	
static func get_player(root : Node) -> SPPlayer3D:
	for child in root.get_children(true):
		if(child.get_script() == load("res://scripts/classes/sp_player_3d.gd")):
			return child
			
	return null
	
static func vectors_approx_equal(v1 : Vector3, v2 : Vector3, epsilon : float) -> bool:
	var difference : Vector3 = v1 - v2
	return (abs(difference.x) < epsilon) and (abs(difference.y) < epsilon) and (abs(difference.z) < epsilon)
	
static func play_3d_sound_at(sound : AudioStreamMP3, location : Vector3, parent : Node, config : AudioStream3DData) -> void:
	var audio_stream : AudioStreamPlayer3D = AudioStreamPlayer3D.new()
	parent.add_child(audio_stream)
	audio_stream.stream = sound
	audio_stream.global_position = location
	audio_stream.max_db = config.max_db
	audio_stream.max_distance = config.max_distance
	audio_stream.volume_db = config.volume_db
	audio_stream.pitch_scale = config.pitch_scale
	audio_stream.unit_size = config.unit_size
	audio_stream.set_bus("Effects")
	audio_stream.finished.connect(Callable(func() -> void:
		audio_stream.queue_free()
	))
	audio_stream.play(config.sound_start)
