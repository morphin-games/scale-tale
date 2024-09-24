extends Node3D

var open : bool = false

func _on_player_detect_area_3d_player_entered(player : SPPlayer3D) -> void:
	if(open): return
	
	open = true
	$AnimationPlayer.play("open")
