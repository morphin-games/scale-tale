extends Node

signal grabable_added
signal grabable_removed

var player : SPPlayer3D
var grabables_near_player : Array[Grabable3D]
var all_disabled : bool = false

func add_grabable(grabable : Grabable3D) -> void:
	grabables_near_player.append(grabable)
	#print(grabables_near_player)
	emit_signal("grabable_added")
	
func remove_grabable(grabable : Grabable3D) -> void:
	grabable.enabled = true
	grabables_near_player.erase(grabable)
	#print(grabables_near_player)
	emit_signal("grabable_removed")
	
func _process(delta: float) -> void:
	if(grabables_near_player.size() <= 0 or player == null): return
	grabables_near_player.sort_custom(Callable(func(a : Grabable3D, b : Grabable3D) -> bool:
		return (player.global_position - a.item.global_position).length() < (player.global_position - b.item.global_position).length()
	))
	
	for i in range(0, grabables_near_player.size()):
		grabables_near_player[i].enabled = false
	
	if(!all_disabled):
		grabables_near_player[0].enabled = true
