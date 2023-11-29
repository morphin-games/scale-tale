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
@export var interaction_sprite_pc : Texture2D
@export var interaction_sprite_console : Texture2D
@export var fixed_rotation : bool = true
@export var npc_dialog : NpcDialog3D
@export var grabable : Grabable3D

@onready var interaction_sprite : Texture2D = interaction_sprite_console

var current_scale : Vector3 = Vector3.ONE
var player_near : SPPlayer3D
var player_near_persist : SPPlayer3D
var enabled : bool = true

func _ready() -> void:
	$InteractionSprite.texture = interaction_sprite
	set_process(fixed_rotation)
	if(grabable != null):
		grabable.grabbed.connect(Callable(func() -> void:
			$InteractionSprite.visible = false
		))
		
		grabable.ungrabbed.connect(Callable(func() -> void:
			if(player_near == null): return
			$InteractionSprite.visible = true
		))
	
func _input(event: InputEvent) -> void:
	if(!enabled) : return
	
	if(event.is_action_pressed("ui_interact") and player_near != null):
		if(player_near.grabbed_item == null):
			emit_signal("interacted")
		
	if(event is InputEventKey or event is InputEventMouseButton or event is InputEventMouseMotion):
		$InteractionSprite.texture = interaction_sprite_pc
	elif(event is InputEventJoypadButton or event is InputEventJoypadMotion):
		$InteractionSprite.texture = interaction_sprite_console
	
func _unhandled_input(event: InputEvent) -> void:
	if(!enabled) : return
	if(event is InputEventKey or event is InputEventMouseButton or event is InputEventMouseMotion):
		$InteractionSprite.texture = interaction_sprite_pc
	elif(event is InputEventJoypadButton or event is InputEventJoypadMotion):
		$InteractionSprite.texture = interaction_sprite_console
	
func _process(delta: float) -> void:
	global_rotation_degrees = Vector3.ZERO
	scale = current_scale

func _on_body_entered(body: Node3D) -> void:
	if(!enabled) : return
	if(body.name == "Player"):
		if(player_near_persist == null):
			player_near_persist = body
			(player_near_persist as SPPlayer3D).grabbed_item_changed.connect(Callable(func(p_body : PhysicsBody3D) -> void:
				if(player_near != null):
					if(p_body == null):
						$InteractionSprite.visible = true
					else:
						$InteractionSprite.visible = false
			))
			
		if(show_interaction_sprite and (body as SPPlayer3D).grabbed_item == null and GrabableDistanceSystem.grabables_near_player.size() == 0):
			$InteractionSprite.visible = true
		if(highlight_mesh != null):
			highlight_mesh.get_active_material(material_surface).set_shader_parameter("outline_width", 5)
			highlight_mesh.get_active_material(material_surface).set_shader_parameter("outline_color", interaction_color)
		player_near = body
		if(grabable != null):
			GrabableDistanceSystem.add_grabable(grabable)
		
func _on_body_exited(body: Node3D) -> void:
	if(body.name == "Player"):
		$InteractionSprite.visible = false
		if(highlight_mesh != null):
			highlight_mesh.get_active_material(material_surface).set_shader_parameter("outline_width", 0)
		player_near = null
		if(grabable != null):
			GrabableDistanceSystem.remove_grabable(grabable)
		if(npc_dialog != null):
			npc_dialog.dialog_active = false
	if DialogManager.is_dialog_active:
		if DialogManager.text_box != null:			
			DialogManager.is_dialog_active = false
			DialogManager.current_line_index = 0
			DialogManager.text_box.queue_free()
