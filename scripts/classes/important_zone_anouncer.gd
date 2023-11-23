class_name ImportantZoneAnouncer
extends Control

@export var anouncer : Label
@export var effect : Label

func anounce(zone_name : String) -> void:
	anouncer.text = zone_name
	effect.text = zone_name
	$AnimationPlayer.play("anounce")
	
