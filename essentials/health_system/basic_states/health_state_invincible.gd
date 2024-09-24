class_name HealthStateInvincible
extends HealthState

var _duration : float
var _infinite : bool
var _spawn_health : int

func enter() -> void:
	_spawn_health = _health.health
	_health.prevent_damage = true
	_health.prevent_damage_signals = true

func exit() -> void:
	_health.prevent_damage = false
	_health.prevent_damage_signals = false

func process(delta : float) -> void:
	_health.prevent_damage = true
	_health.prevent_damage_signals = true
	_duration -= delta
	if(_health.health < _spawn_health):
		_health.health = _spawn_health
	elif(_health.health > _spawn_health):
		_spawn_health = _health.health
	if(_duration <= 0.0 and !_infinite):
		erase_self()

func _init(duration : float, infinite : bool = false) -> void:
	_duration = duration
	_infinite = infinite
	
func get_state_name() -> String:
	return "HealthStateInvincible"

static func get_state_static_name() -> String:
	return "HealthStateInvincible"
