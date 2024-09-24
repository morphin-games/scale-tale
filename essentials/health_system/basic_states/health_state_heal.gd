class_name HealthStateHeal
extends HealthState

var _counter : float = 0.0
var _times_applied : int = 0
var _total_amount : int
var _ticks : int
var _duration : float
var _infinite : bool

func _init(total_amount : int, ticks : int, duration : float, infinite : bool = false):
	_total_amount = total_amount
	_ticks = ticks
	_duration = duration
	_infinite = infinite
	_counter = _duration / _ticks

func process(delta : float) -> void:
	_counter += delta
	if(_counter >= _duration / _ticks):
		_counter = 0
		_health.heal(_total_amount / _ticks)
		_times_applied += 1
	if(_times_applied >= _ticks):
		erase_self()

func allows_multiple() -> bool:
	return true

func get_state_name() -> String:
	return "HealthStateHeal"

static func get_state_static_name() -> String:
	return "HealthStateHeal"
