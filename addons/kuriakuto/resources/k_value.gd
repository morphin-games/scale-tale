class_name KValue
extends KResource

signal value_changed

# Private
var _kuriakuto_property_name : String

# Public
var value : Variant : 
	set(new_value):
		value = new_value
		emit_signal("value_changed")
	get:
		return value

func _init(name : String, value : Variant) -> void:
	self._kuriakuto_property_name = name
	self.value = value
	kuriakuto_unique_id = (str(randi_range(1_000_000, 9_999_999)) + name).md5_text() + "_" + name
	KuriakutoCore.register(self)
	
func get_kuriakuto_name() -> String:
	return _kuriakuto_property_name
