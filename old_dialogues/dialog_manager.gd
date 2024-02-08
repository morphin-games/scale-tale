#extends Node
#
#@onready var phantom_camera_host
##@onready var textbox_scene = preload("res://dialogues/textbox/text_box.tscn")
#
#var player 
#var dialog_lines: Array = []
#var current_line_index = 0
#
#var text_box
#var text_box_position: Vector3
#
#var is_dialog_active = false
#var can_advance_line = false
#var player_can_move = true
#
#var npc : NpcDialog3D
#var sfx: AudioStreamPlayer3D
#
#func _ready() -> void:
	#phantom_camera_host = get_node("/root/FinalLevel/CameraFollow3D/PhantomCameraHost")
	#player=get_node("/root/FinalLevel/Player")
	#print("phantom",phantom_camera_host)
	#phantom_camera_host.process_mode = Node.PROCESS_MODE_DISABLED
	#
#func start_dialog(position: Vector3, lines: Array[String], sfx_speech: AudioStreamPlayer3D, npc : NpcDialog3D):
	#if is_dialog_active:
		#if(text_box != null):
			#text_box.speed = 3.0
		#return
	#dialog_lines = lines
	#text_box_position = Vector3(position.x,position.y + 2 , position.z)
	#sfx = sfx_speech
	#show_text_box()
	#self.npc = npc
	#is_dialog_active = true
	#player.active_dialog()
	#phantom_camera_host.process_mode = Node.PROCESS_MODE_INHERIT
	#
#
#func show_text_box():
	#text_box = textbox_scene.instantiate()
	#text_box.finished_displaying.connect(_on_text_box_finished_displaying)
	#get_tree().root.add_child(text_box)
	#text_box.global_position = text_box_position
	#text_box.display_text(dialog_lines[current_line_index],sfx)
	#can_advance_line = false
#	(text_box as Sprite3D).no_depth_test = true
#
#func _on_text_box_finished_displaying():
	#can_advance_line = true
	#
#func _unhandled_input(event: InputEvent) -> void:
	#if(event.is_action_pressed("ui_interact") && is_dialog_active && can_advance_line):
		#if text_box != null:
			#text_box.queue_free()
#
		#current_line_index += 1
		#if current_line_index >= dialog_lines.size():
			#is_dialog_active = false
			#current_line_index = 0
			#npc.dialog_active = false
			#phantom_camera_host.process_mode = Node.PROCESS_MODE_DISABLED
			#player.end_dialog()
			#return
		#show_text_box()
