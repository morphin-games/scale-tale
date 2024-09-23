class_name KXInputList
extends VBoxContainer

@export_group("Container configuration")
@export var kxrow_separation : int = 25
@export var input_button_size : int = 70
@export var button_texture_size : int = 50
@export_group("Inputs")
@export var translate_input_names : bool = false
@export var total_input_slots : int = 1
@export var input_textures : KXTextures

func _ready() -> void:
	if(Keyxplorer.keyxplorer_map == null):
		push_warning("Keyxplorer is not set up, be sure to call Keyxplorer.setup(...) when setting up your game.")
		return
	if(total_input_slots < 1):
		total_input_slots = 1
	elif(total_input_slots > 4):
		total_input_slots = 4
	setup()
		
func setup() -> void:
	for keyxplorer_input in Keyxplorer.keyxplorer_map.keyxplorer_inputs:
		var row : KXInputRow = KXInputRow.new(
			self,
			keyxplorer_input,
		)
		row.input_remapped.connect(Callable(func() -> void:
			for child in get_children():
				remove_child(child)
			setup()
		))
		add_child(row)
