class_name HealthSystem
extends Node

signal died
signal healed
signal damaged
signal health_changed

@export var max_health : int = 6

@onready var health : float = max_health

var damage_frozen : bool = false
var respawning : bool = false

func damage(ammount : int) -> void:
	#print(health)
	if(damage_frozen or respawning) : return
	health -= ammount
	emit_signal("damaged")
	emit_signal("health_changed")
	if(health <= 0):
		health = 0
		emit_signal("died")
		emit_signal("health_changed")
		
func heal(ammount : int) -> void:
	health += ammount
	emit_signal("healed")
	if(health >= max_health):
		health = max_health
		emit_signal("health_changed")
