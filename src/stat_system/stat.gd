class_name Stat
extends Resource

@export var stat_name : String
@export var stat_default : float = 1.0
@export var stat_modifiers : Array[StatModifier]

func add_modifier(stat_modifier : StatModifier) -> StatModifier:
	stat_modifiers.append(stat_modifier)
	return stat_modifiers[stat_modifiers.size()]

func remove_modifier(stat_modifier : StatModifier) -> void:
	stat_modifiers.erase(stat_modifier)
