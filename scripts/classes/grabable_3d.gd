class_name Grabable3D
extends Node

@export var item : Node3D
@export var interactuable : Interactuable3D

var player : SPPlayer3D
var time_taken : float

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("ui_interact") and Time.get_unix_time_from_system() - time_taken > 0.33):
		if(player != null):
			drop()
			player = null
			
	if(event.is_action_pressed("ui_throw") and Time.get_unix_time_from_system() - time_taken > 0.33):
		if(player != null):
			throw()
			player = null

func _ready() -> void:
	interactuable.interacted.connect(Callable(func() -> void:
		if(player != null) : return
		if(player == null):
			player = interactuable.player_near
			grab()
			time_taken = Time.get_unix_time_from_system()
	))
	

func grab() -> void:
	if(player.grabbed_item == null):
		player.grabbed_item = item
		
func drop() -> void:
	player.grabbed_item = null
	
func throw() -> void:
	pass
