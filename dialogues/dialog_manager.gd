extends Node


@onready var textbox_scene = preload("res://dialogues/textbox/text_box.tscn")

var dialog_lines: Array = []
var current_line_index = 0

var text_box
var text_box_position: Vector3

var is_dialog_active = false
var can_advance_line = false

var sfx: AudioStreamPlayer3D

func start_dialog(position: Vector3, lines: Array[String], sfx_speech: AudioStreamPlayer3D):
	if is_dialog_active:
		return
	dialog_lines = lines
	print(position)
	text_box_position = Vector3(position.x,position.y + 5 , position.z)
	print(text_box_position)
	sfx = sfx_speech
	show_text_box()
	
	is_dialog_active = true

func show_text_box():
	text_box = textbox_scene.instantiate()
	text_box.finished_displaying.connect(_on_text_box_finished_displaying)
	get_tree().root.add_child(text_box)
	text_box.global_position = text_box_position
	text_box.display_text(dialog_lines[current_line_index],sfx)
	can_advance_line = false

func _on_text_box_finished_displaying():
	can_advance_line = true
	
func _unhandled_input(event: InputEvent) -> void:
	if(event.is_action_pressed("ui_interact") && is_dialog_active && can_advance_line):
		text_box.queue_free()

		current_line_index += 1
		if current_line_index >= dialog_lines.size():
			is_dialog_active = false
			current_line_index = 0
			return
		show_text_box()
