class_name ImportantZoneArea3D
extends Area3D

signal important_zone_entered

@export var zone_name : String = "Unnamed"
@export var ui : ImportantZoneAnouncer
@export var sfx : AudioStreamPlayer
@onready var music_overworld = $"../../MusicOverworld"
@onready var music_over_secret = $"../../MusicSecretOverworld"

var played : bool = false

func _ready() -> void:
	body_entered.connect(Callable(func(body : PhysicsBody3D) -> void:
		if(played) : return
		if(body.name == "Player"):
			#print("lol")	
			#print("pririri")
			played = true
			ui.anounce(zone_name)
			if(sfx != null):
				sfx.play()
	))
	
	body_exited.connect(Callable(func(body : PhysicsBody3D) -> void:
		if(body.name == "Player"):
			#print("lol")
			played = false
	))
