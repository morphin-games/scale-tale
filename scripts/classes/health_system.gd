class_name HealthSystem
extends Node

signal died
signal healed
signal damaged

@export var max_health : int = 6

@onready var health : int = max_health

func damage(ammount : int) -> void:
	health -= ammount
	emit_signal("damaged")
	if(health <= 0):
		health = 0
		emit_signal("died")
		
func heal(ammount : int) -> void:
	health += ammount
	emit_signal("healed")
	if(health >= max_health):
		health = max_health
