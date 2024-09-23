@icon("ihealth.svg")
class_name Health
## Health class to add health functionality to any node.
extends Node

## Emitted when [member health] changes
signal health_changed(amount : int)
## Emitted when [member health] is depleted
signal fully_damaged
## Emitted when [member health] is full again
signal fully_healed
## Emitted when [member health] increases above [member max_health]
signal overhealed(amount : int)
## Emitted when [member health] decreases
signal damaged(amount : int)
## Emitted when [member health] increases
signal healed(amount : int)

## When true, disable emission of healing signals, useful when making a [HealthState]
@onready var prevent_heal_signals : bool = false
## When true, disable emission of damage signals, useful when making a [HealthState]
@onready var prevent_damage_signals : bool = false
## When true, disable healing, useful when making a [HealthState]
@onready var prevent_heal : bool = false
## When true, disable damage, useful when making a [HealthState]
@onready var prevent_damage : bool = false

@export var max_health : int = 100 : 
	set(new_value):
		if(new_value == max_health): return
		max_health = new_value
		if(heal_on_set_max_health):
			health = new_value
	get:
		return max_health
		
@export var health : int = 100 :
	set(new_value):
		if(new_value == health): return
		if(new_value > health and prevent_heal): return
		if(new_value < health and prevent_damage): return
		var change : int = new_value
		if(new_value >= max_health):
			_emit_heal_signal("fully_healed")
			if(new_value > max_health):
				_emit_heal_signal("overhealed", new_value - health)
				change = max_health
		elif(new_value <= 0):
			_emit_damage_signal("fully_damaged")
			if(new_value < 0):
				change = 0
		if(health < new_value):
			_emit_heal_signal("healed", change)
		elif(health > new_value):
			_emit_damage_signal("damaged", change)
		if(change > health):
			health = change
			_emit_heal_signal("health_changed", change)
		elif(change < health):
			health = change
			_emit_damage_signal("health_changed", change)
	get:
		return health
		
## Makes [member health] be fully healed whenever [member max_health] is set
@export var heal_on_set_max_health : bool = false
@export var max_health_states : int = 5

var health_states : Array[HealthState]

## Adds [param ammount] of [member health]
func heal(amount : int) -> void:
	if(prevent_heal): return
	var total_healed : int = amount
	if(health + amount >= max_health):
		total_healed = max_health - health
		health = max_health
		_emit_heal_signal("fully_healed")
		if(total_healed > 0):
			_emit_heal_signal("overhealed", total_healed)
	else:
		health += amount
	_emit_heal_signal("healed", total_healed)
	_emit_heal_signal("health_changed", total_healed)
	
## Reduces [param ammount] of [member health]
func damage(amount : int) -> void:
	if(prevent_damage): return
	var total_damaged : int = amount
	if(health - amount <= 0):
		total_damaged = amount - abs(health - amount)
		health = 0
		_emit_damage_signal("fully_damaged")
	else:
		health -= amount
	_emit_damage_signal("damaged", total_damaged)
	_emit_damage_signal("health_changed", total_damaged * -1)
	
## Add a HealthState that will modify behaviour of Health
func add_state(new_health_state : HealthState) -> void:
	if(health_states.size() >= max_health_states): return
	var same_state_applied : bool = false
	for health_state in health_states:
		if(health_state.get_state_name() == new_health_state.get_state_name()):
			same_state_applied = true
			break
	if(same_state_applied and !new_health_state.allows_multiple()): return
	health_states.append(new_health_state)
	new_health_state.link_health(self)
	new_health_state.enter()
	
func remove_state(health_state_name : String) -> void:
	for health_state in health_states:
		if(health_state.get_state_name() == health_state_name):
			health_state.exit()
			health_states.erase(health_state)
			break
			
func remove_all_states(health_state_name : String) -> void:
	for health_state in health_states:
		if(health_state.get_state_name() == health_state_name):
			health_state.exit()
			health_states.erase(health_state)
			
func _emit_heal_signal(signal_name : StringName, parameter : Variant = null) -> void:
	if(prevent_heal_signals): return
	emit_signal(signal_name, parameter)
	
func _emit_damage_signal(signal_name : StringName, parameter : Variant = null) -> void:
	if(prevent_damage_signals): return
	emit_signal(signal_name, parameter)

func _process(delta : float) -> void:
	for health_state in health_states:
		health_state.process(delta)
