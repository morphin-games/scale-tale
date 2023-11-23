class_name NpcDialog3D
extends Node3D

#@onready var speech_sound:AudioStream = preload("res://art/sfx/talk_effect.wav")
@onready var speech_sound = $AudioStreamPlayer3D
var dialog_active = false : 
	set(active):
		dialog_active = active
		$Interactuable.visible = !active
var current_dialogue_id = 0
@export var npc_name = ""

var dialogue: Array[String] = []
var dialog_file = "res://dialogues/json/dialog_test.json"


func _ready() -> void:
	var file = FileAccess.open(dialog_file, FileAccess.READ)
	var content = file.get_as_text()
	var json = JSON.new()
	var finish = JSON.parse_string(content)	
	
	for i in finish:
		if i["name"] == npc_name:
			dialogue.append(i["text"])
	print(dialogue)

#func _unhandled_input(event: InputEvent) -> void:
#	if event.is_action_pressed("ui_grab"):
#		if $Interactuable.get_overlapping_bodies().size() > 0:
#			DialogManager.start_dialog(global_position, dialogue)
		

func _on_interactuable_interacted() -> void:
	dialog_active = true
	DialogManager.start_dialog(global_position, dialogue, speech_sound, self)
