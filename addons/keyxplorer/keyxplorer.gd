extends Node

## Autosave the KeyxplorerMap resource on each input remap.
var autosave : bool
## KeyxplorerMap resource containing all the input information.
## When remapping an input, this Resource is saved with the new information.
var keyxplorer_map : KXMap
# Internal private value to know where to save.
var _keyxplorer_map_path : String

## Function to setup the inputs for the game. 
## This function MUST be called, preferably at the initialization of the game itself.
func setup(keyxplorer_map_path : String, autosave : bool = true) -> void:
	self.autosave = autosave
	_keyxplorer_map_path = keyxplorer_map_path
	keyxplorer_map = ResourceLoader.load(keyxplorer_map_path)
	for keyxplorer_input in keyxplorer_map.keyxplorer_inputs:
		InputMap.add_action(keyxplorer_input.input_name)
		if(keyxplorer_input.slot_1 != null):
			InputMap.action_add_event(keyxplorer_input.input_name, keyxplorer_input.slot_1)
		if(keyxplorer_input.slot_2 != null):
			InputMap.action_add_event(keyxplorer_input.input_name, keyxplorer_input.slot_2)
		if(keyxplorer_input.slot_3 != null):
			InputMap.action_add_event(keyxplorer_input.input_name, keyxplorer_input.slot_3)
		if(keyxplorer_input.slot_4 != null):
			InputMap.action_add_event(keyxplorer_input.input_name, keyxplorer_input.slot_4)

## Save the KeyxplorerMap to disk.
func save() -> void:
	ResourceSaver.save(keyxplorer_map, _keyxplorer_map_path)

## Reload the InputMap actions.
## MUST be called after modifying the [member keyxplorer_map] for the new actions to take place.
func reload() -> void:
	for keyxplorer_input in keyxplorer_map.keyxplorer_inputs:
		InputMap.erase_action(keyxplorer_input.input_name)
	if(autosave):
		save()
	setup(_keyxplorer_map_path)
