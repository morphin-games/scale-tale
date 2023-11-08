# This scene acts as a way to add interactions to scenes.
# By default it has no collision shape as it's intended to be added for each specific case.
# Remember that changing the collision shape shared by many scenes makes every collision shape update, unless they are unique.

class_name Interactuable3D
extends Area3D

signal interacted

@export var show_interaction_sprite : bool = true

var player_near : SPPlayer3D

func _on_body_entered(body: Node3D) -> void:
	if(body.name == "Player"):
		if(show_interaction_sprite):
			$InteractionSprite.visible = true
		player_near = body
		
func _on_body_exited(body: Node3D) -> void:
	if(body.name == "Player"):
		$InteractionSprite.visible = false
		player_near = null
		
func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("ui_interact") and player_near != null):
		emit_signal("interacted")
