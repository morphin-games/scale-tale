class_name Utils
extends Node

static func find_children_of_class(root : Node, find_class : String, recursive : bool = false) -> Array[Node]:
	var nodes : Array[Node] = []
	for node in root.get_children(recursive):
		if(node.get_class() == find_class):
			nodes.append(node)
		
	return nodes

static func find_custom_nodes(root : Node, find_class : String, recursive : bool = false) -> Array[Node]:
	var nodes : Array[Node] = []
	for node in root.get_children(recursive):
		if(node.get_script() == load(find_class)):
			nodes.append(node)
		
	return nodes
	
static func find_multiple_custom_nodes(root : Node, find_classes : Array[String], recursive : bool = false) -> Array[Node]:
	var nodes : Array[Node] = []
	for node in root.get_children(recursive):
		for j in range(0, find_classes.size()):
			if(node.get_script() == load(find_classes[j])):
				nodes.append(node)
		
	return nodes
