# This scene acts as a way to add interactions to scenes.
# By default it has no collision shape as it's intended to be added for each specific case.
# Remember that changing the collision shape shared by many scenes makes every collision shape update, unless they are unique.

class_name Interactuable3D
extends Area3D

signal interacted

@export var show_interaction_sprite : bool = true
@export var highlight_mesh : MeshInstance3D
@export var material_surface : int = 0
@export var interaction_color : Color

var player_near : SPPlayer3D

func _on_body_entered(body: Node3D) -> void:
	if(body.name == "Player"):
		if(show_interaction_sprite):
			$InteractionSprite.visible = true
		if(highlight_mesh != null):
			highlight_mesh.get_active_material(material_surface).set_shader_parameter("outline_width", 5)
			highlight_mesh.get_active_material(material_surface).set_shader_parameter("outline_color", interaction_color)
		player_near = body
		
func _on_body_exited(body: Node3D) -> void:
	if(body.name == "Player"):
		$InteractionSprite.visible = false
		if(highlight_mesh != null):
			highlight_mesh.get_active_material(material_surface).set_shader_parameter("outline_width", 0)
		player_near = null
	if DialogManager.is_dialog_active:
		if DialogManager.text_box != null:			
			DialogManager.is_dialog_active = false
			DialogManager.current_line_index = 0
			DialogManager.text_box.queue_free()


		
func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("ui_interact") and player_near != null):
		emit_signal("interacted")
