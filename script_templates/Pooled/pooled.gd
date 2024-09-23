class_name _CLASS_
extends Pooled

# Virtual function.
# Add your own deactivation condition. This function must return a boolean (true -> deactivates, false -> keeps active).
func deactivation_condition() -> bool:
	return true
