class_name NpcDialog3D
extends Node3D

@export var interactuable : Interactuable3D

#@onready var speech_sound:AudioStream = preload("res://art/sfx/talk_effect.wav")
@onready var speech_sound = $AudioStreamPlayer3D
var dialog_active = false : 
	set(active):
		dialog_active = active
		$Interactuable.visible = !active
var current_dialogue_id = 0
@export var npc_name = "" : 
	set(new_name):
		npc_name = new_name
		var file = FileAccess.open(dialog_file, FileAccess.READ)
		var content = file.get_as_text()
		var json = JSON.new()
		var finish = JSON.parse_string(content)	
		
		dialogue = []
		for i in finish:
			if i["name"] == npc_name:
				dialogue.append(i["text"])

var dialogue: Array[String] = []
var dialog_file = "res://dialogues/json/dialog_test.json"


func _ready() -> void:
	var file = FileAccess.open(dialog_file, FileAccess.READ)
	var content = file.get_as_text()
	var json = JSON.new()
	var finish = JSON.parse_string(content)	
	
	dialogue = []
	for i in finish:
		if i["name"] == npc_name:
			dialogue.append(i["text"])

#func _unhandled_input(event: InputEvent) -> void:
#	if event.is_action_pressed("ui_grab"):
#		if $Interactuable.get_overlapping_bodies().size() > 0:
#			DialogManager.start_dialog(global_position, dialogue)
		

func _on_interactuable_interacted() -> void:
	dialog_active = true
	DialogManager.start_dialog(global_position, dialogue, speech_sound, self)


func _on_interactuable_body_exited(body: Node3D) -> void:
	if(DialogManager.is_dialog_active):
		DialogManager.is_dialog_active = false
		DialogManager.text_box.queue_free()
		DialogManager.can_advance_line = false
		DialogManager.current_line_index = 0
		DialogManager.dialog_lines = []
