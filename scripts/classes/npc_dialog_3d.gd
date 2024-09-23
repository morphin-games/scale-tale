class_name NpcDialog3D
extends Node3D

@onready var phantom_camera_host
var player 
@export var interactuable : Interactuable3D

#@onready var speech_sound:AudioStream = preload("res://art/sfx/talk_effect.wav")
@onready var speech_sound = $AudioStreamPlayer3D
#var dialog_active = false : 
	#set(active):
		#dialog_active = active
		#$Interactuable.visible = !active
#var current_dialogue_id = 0
#@export var npc_name = "" : 
	#set(new_name):
		#npc_name = new_name
		#var file = FileAccess.open(dialog_file, FileAccess.READ)
		#var content = file.get_as_text()
		#var json = JSON.new()
		#var finish = JSON.parse_string(content)	
		#
		#dialogue = []
		#for i in finish:
			#if i["name"] == npc_name:
				#dialogue.append(i["text"])
#
#var dialogue: Array[String] = []
#var dialog_file = "res://dialogues/json/dialog_test.json"


func _ready() -> void:
	phantom_camera_host = get_node("/root/FinalLevel/CameraFollow3D/PhantomCameraHost")
	player=get_node("/root/FinalLevel/Player")
	#print("phantom",phantom_camera_host)
	phantom_camera_host.process_mode = Node.PROCESS_MODE_DISABLED
	#var file = FileAccess.open(dialog_file, FileAccess.READ)
	#var content = file.get_as_text()
	#var json = JSON.new()
	#var finish = JSON.parse_string(content)	
	#
	#
	#dialogue = []
	#for i in finish:
		#if i["name"] == npc_name:
			#dialogue.append(i["text"])

#func _unhandled_input(event: InputEvent) -> void:
#	if event.is_action_pressed("ui_grab"):
#		if $Interactuable.get_overlapping_bodies().size() > 0:
#			DialogManager.start_dialog(global_position, dialogue)
		

func _on_interactuable_interacted() -> void:
	#dialog_active = true
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	Dialogic.start("test_timeline")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	player.active_dialog()
	phantom_camera_host.process_mode = Node.PROCESS_MODE_INHERIT
	#DialogManager.start_dialog(global_position, dialogue, speech_sound, self)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _on_timeline_ended():
	phantom_camera_host.process_mode = Node.PROCESS_MODE_DISABLED
	player.end_dialog()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
#func _on_interactuable_body_exited(body: Node3D) -> void:
	#if(DialogManager.is_dialog_active):
		#DialogManager.is_dialog_active = false
		#DialogManager.text_box.queue_free()
		#DialogManager.can_advance_line = false
		#DialogManager.current_line_index = 0
		#DialogManager.dialog_lines = []
