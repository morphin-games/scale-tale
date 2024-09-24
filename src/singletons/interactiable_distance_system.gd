extends Node

signal interactuable_added
signal interactuable_removed

var player : SPPlayer3D
var interactuables_near_player : Array[Interactuable3D]
var all_disabled : bool = false

func add_interactuable(interactuable : Interactuable3D) -> void:
	interactuables_near_player.append(interactuable)
	#print(interactuables_near_player)
	emit_signal("interactuable_added")
	
func remove_interactuable(interactuable : Interactuable3D) -> void:
	interactuable.enabled = false
	interactuables_near_player.erase(interactuable)
	#print(interactuables_near_player)
	emit_signal("interactuable_removed")
	
func _process(delta: float) -> void:
	if(interactuables_near_player.size() <= 0 or player == null): return
	interactuables_near_player.sort_custom(Callable(func(a : Interactuable3D, b : Interactuable3D) -> bool:
		return (player.global_position - a.global_position).length() < (player.global_position - b.global_position).length()
	))
	
	if(player.grabbed_item != null):
		all_disabled = true
	else:
		all_disabled = false
	
	for i in range(0, interactuables_near_player.size()):
		interactuables_near_player[i].enabled = false
	
	if(!all_disabled):
		interactuables_near_player[0].enabled = true
