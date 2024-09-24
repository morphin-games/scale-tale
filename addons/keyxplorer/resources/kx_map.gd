@icon("ikx_map.svg")
class_name KXMap
## Resource containing all custom Inputs inside.
## The remappings will happen inside this resource, and then saved to disk.
## To use, create a new KeyxplorerMap resource in the FileSystem, and fill it with [KeyxplorerInput] entries inside [member keyxplorer_inputs]
extends Resource

enum KXInputSlot {
	SLOT_1,
	SLOT_2,
	SLOT_3,
	SLOT_4,
}

## Array of [KeyxplorerInput]. Each KeyxplorerInput acts as a custom InputMap that can be remapped.
@export var keyxplorer_inputs : Array[KXInput]

func remap_input(keyxplorer_input_name : String, keyxplorer_input_slot : KXInputSlot, input : InputEvent) -> void:
	for keyxplorer_input in keyxplorer_inputs:
		if(keyxplorer_input.input_name == keyxplorer_input_name):
			match keyxplorer_input_slot:
				KXInputSlot.SLOT_1:
					keyxplorer_input.slot_1 = input
				KXInputSlot.SLOT_2:
					keyxplorer_input.slot_2 = input
				KXInputSlot.SLOT_3:
					keyxplorer_input.slot_3 = input
				KXInputSlot.SLOT_4:
					keyxplorer_input.slot_4 = input
	Keyxplorer.reload()
