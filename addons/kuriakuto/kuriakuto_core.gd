extends Node

signal kuriakuto_resource_added(kuriakuto_resource : KResource)

enum KuriakutoWarns {
	KURIAKUTO_RESOURCE_DOESNT_EXIST,
	KURIAKUTO_PROPERTY_DOESNT_EXIST,
	KURIAKUTO_VALUE_DOESNT_EXIST,
	KURIAKUTO_COMPUTED_DOESNT_EXIST,
	
	KURIAKUTO_OBSERVABLE_DOESNT_EXIST,
	KURIAKUTO_OBSERVABLE_ALREADY_EXISTS,
}

## List of all declared KuriakutoResources.
var _kuriakuto_resources : Dictionary
## Kuriakuto Properties are values linked to a node property, with their own logic.
var _kuriakuto_properties : Dictionary
var _observables : Dictionary

func _warn(error : KuriakutoWarns, extra : Variant = null) -> void:
	match error:
		KuriakutoWarns.KURIAKUTO_RESOURCE_DOESNT_EXIST:
			push_warning("KResource \"" + extra + "\" does not exist")
		KuriakutoWarns.KURIAKUTO_PROPERTY_DOESNT_EXIST:
			push_warning("KProperty \"" + extra + "\" does not exist")
		KuriakutoWarns.KURIAKUTO_VALUE_DOESNT_EXIST:
			push_warning("KValue \"" + extra + "\" does not exist")
		KuriakutoWarns.KURIAKUTO_COMPUTED_DOESNT_EXIST:
			push_warning("KComputed \"" + extra + "\" does not exist")
		KuriakutoWarns.KURIAKUTO_OBSERVABLE_DOESNT_EXIST:
			push_warning("Observable \"" + extra + "\" does not exist")
		KuriakutoWarns.KURIAKUTO_OBSERVABLE_ALREADY_EXISTS:
			push_warning("Observable \"" + extra + "\" already exists")
			
func _get_sync_uid(node : Node, property : StringName, kuriakuto_resource_name : StringName) -> StringName:
	var kresource : KResource = await get_kuriakuto_resource(kuriakuto_resource_name)
	return node.name + "_" + property + "_" + kresource.kuriakuto_unique_id
			
			
			
## Register a new KuriakutoResource, available for global use.
func register(kuriakuto_resource : KResource) -> void:
	if(kuriakuto_resource is KProperty):
		_kuriakuto_properties[kuriakuto_resource.get_kuriakuto_name()] = kuriakuto_resource
		_kuriakuto_resources[kuriakuto_resource.get_kuriakuto_name()] = _kuriakuto_properties[kuriakuto_resource.get_kuriakuto_name()]
	else:
		_kuriakuto_resources[kuriakuto_resource.get_kuriakuto_name()] = kuriakuto_resource
	kuriakuto_resource_added.emit(kuriakuto_resource)
		
## Deregister (by name) an existing KuriakutoResource
func deregister(kuriakuto_resource_name : StringName) -> void:
	_kuriakuto_resources.erase(kuriakuto_resource_name)
	
## Watch (by name) for a specific KuriakutoResource value changes.
## Will react accordingly calling the given Callable.
func watch(kuriakuto_resource_name : StringName, callable : Callable) -> void:
	if(!_kuriakuto_resources.has(kuriakuto_resource_name)): 
		_warn(KuriakutoWarns.KURIAKUTO_PROPERTY_DOESNT_EXIST, kuriakuto_resource_name)
		return
	_kuriakuto_resources[kuriakuto_resource_name].value_changed.connect(callable)
	
## Return (by name) the value of a registered KuriakutoResource.
## When getting the value of a KuriakutoResource, use this method instead of [method get_kuriakuto_resource].
func get_value(kuriakuto_resource_name : StringName) -> Variant:
	if(!_kuriakuto_resources.has(kuriakuto_resource_name)) : return null
	return _kuriakuto_resources[kuriakuto_resource_name].value
	
## Return (by name) a registered KuriakutoResource.
func get_kuriakuto_resource(kuriakuto_resource_name : StringName) -> KResource:
	if(!_kuriakuto_resources.has(kuriakuto_resource_name)):
		await kuriakuto_resource_added
		get_kuriakuto_resource(kuriakuto_resource_name)
	return _kuriakuto_resources[kuriakuto_resource_name]
	
## Return all the KuriakutoResources that are registered.
func get_kuriakuto_resources() -> Dictionary:
	return _kuriakuto_resources
	
## Sync a KuriakutoResource (by name) to a node property.
## Every change to the KuriakutoResource's value will be reflected on the node's property.
func sync(node : Node, property : StringName, kuriakuto_resource_name : StringName) -> void:
	var uid : StringName = await _get_sync_uid(node, property, kuriakuto_resource_name)
	if(_observables.has(uid)): 
		_warn(KuriakutoWarns.KURIAKUTO_OBSERVABLE_DOESNT_EXIST, uid)
		return
	if(!_kuriakuto_resources.has(kuriakuto_resource_name)): 
		_warn(KuriakutoWarns.KURIAKUTO_PROPERTY_DOESNT_EXIST, kuriakuto_resource_name)
		return
	var callable : Callable = Callable(func() -> void:
		node.set(property, get_value(kuriakuto_resource_name))
	)
	_kuriakuto_resources[kuriakuto_resource_name].value_changed.connect(callable)
	_observables[uid] = callable
	# Initial value set (only for KProperty)
	if(_kuriakuto_properties.has(kuriakuto_resource_name)):
		_kuriakuto_properties[kuriakuto_resource_name].value = _kuriakuto_properties[kuriakuto_resource_name].get_node_value()
		_kuriakuto_resources[kuriakuto_resource_name] = _kuriakuto_properties[kuriakuto_resource_name]
	# Initial value set (only for KValue)
	else:
		node.set(property, get_value(kuriakuto_resource_name))

## Returns if KuriakutoResource (by name) is in sync.
func is_synced(node : Node, property : StringName, kuriakuto_resource_name : StringName) -> void:
	return _observables.has(await _get_sync_uid(node, property, kuriakuto_resource_name))
	
## Desyncs a KuriakutoResource (by name) to a node property.
func desync(node : Node, property : StringName, kuriakuto_resource_name : StringName) -> void:
	var uid : StringName = await _get_sync_uid(node, property, kuriakuto_resource_name)
	if(!_kuriakuto_resources.has(kuriakuto_resource_name)): 
		_warn(KuriakutoWarns.KURIAKUTO_PROPERTY_DOESNT_EXIST, kuriakuto_resource_name)
		return
	if(!_observables.has(uid)): 
		_warn(KuriakutoWarns.KURIAKUTO_OBSERVABLE_DOESNT_EXIST, uid)
		return
	_kuriakuto_resources[kuriakuto_resource_name].value_changed.disconnect(_observables[uid])
	_observables.erase(uid)
	
func reset() -> void:
	_observables.clear()
	_kuriakuto_resources.clear()
	_kuriakuto_properties.clear()
	
	
	
func _process(delta : float) -> void:
	for kuriakuto_property in _kuriakuto_properties.keys():
		if(_kuriakuto_properties[kuriakuto_property].value != _kuriakuto_properties[kuriakuto_property].get_node_value()):
			_kuriakuto_properties[kuriakuto_property].value = _kuriakuto_properties[kuriakuto_property].get_node_value()
			_kuriakuto_resources[kuriakuto_property] = _kuriakuto_properties[kuriakuto_property]
