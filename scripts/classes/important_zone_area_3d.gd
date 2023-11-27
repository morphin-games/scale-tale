class_name ImportantZoneArea3D
extends Area3D

signal important_zone_entered

@export var zone_name : String = "Unnamed"
@export var ui : ImportantZoneAnouncer
@export var sfx : AudioStreamPlayer

func _ready() -> void:
	body_entered.connect(Callable(func(body : PhysicsBody3D) -> void:
		if(body.name == "Player"):
			ui.anounce(zone_name)
			if(sfx != null):
				sfx.play()
	))
