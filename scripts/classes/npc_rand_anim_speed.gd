class_name NPCRandAnimSpeed
extends StaticBody3D

@export var npc_dialog : String
@export var npc_dialog_random : bool

func _ready() -> void:
	$npc_test.npc_name = npc_dialog
	print($npc_test.npc_name)
	var rand : float = randf_range(0.1, 1.0)
	$AnimationPlayer.speed_scale = rand
	$AnimationPlayer.play("idle")
	if(npc_dialog_random):
		rand_dialog()
	
func rand_dialog() -> void:
	npc_dialog = ["NpcRand1", "NpcRand2", "NpcRand3", "NpcRand4", "NpcRand5", "NpcRand6", "NpcRand7", "NpcRand8", "NpcRand9", "NpcRand10"].pick_random()
	$npc_test.npc_name = npc_dialog
	print($npc_test.npc_name)
	await get_tree().create_timer(1.0).timeout
	rand_dialog()
