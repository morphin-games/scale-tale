class_name KXInputRow
extends HBoxContainer

signal input_remapped

class InputSlotEdit extends Resource:
	@export var input_name : String
	@export var slot : KXMap.KXInputSlot

const MIN_MOUSE_MOTION_REMAP : int = 16

var keyxplorer_input : KXInput
var input_slots : Array[InputEvent]
var input_textures : KXTextures
var input_slot_edit : InputSlotEdit

func _init(keyxplorer_input_list : KXInputList, keyxplorer_input : KXInput) -> void:
	self.keyxplorer_input = keyxplorer_input
	self.input_textures = keyxplorer_input_list.input_textures
	input_slots.append(keyxplorer_input.slot_1)
	input_slots.append(keyxplorer_input.slot_2)
	input_slots.append(keyxplorer_input.slot_3)
	input_slots.append(keyxplorer_input.slot_4)
	
	# Self configuration
	alignment = AlignmentMode.ALIGNMENT_BEGIN
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	custom_minimum_size.y = keyxplorer_input_list.input_button_size
	add_theme_constant_override("separation", keyxplorer_input_list.kxrow_separation)
	
	# Input name label, to show the name of the input
	var input_name_label : Label = Label.new()
	input_name_label.text = (tr(keyxplorer_input.show_name) if keyxplorer_input_list.translate_input_names else keyxplorer_input.show_name) + ":"
	input_name_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	input_name_label.custom_minimum_size.x = 150
	input_name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	input_name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	add_child(input_name_label)
	
	for i in range(0, keyxplorer_input_list.total_input_slots):
		var input_button : BaseButton = Button.new()
		if(input_slots[i] is InputEventKey):
			# input_button = Button.new()
			if((input_slots[i] as InputEventKey).key_label != 0):
				input_button.text = (input_slots[i] as InputEventKey).as_text_key_label()
			elif((input_slots[i] as InputEventKey).keycode != 0):
				input_button.text = (input_slots[i] as InputEventKey).as_text_keycode()
			elif((input_slots[i] as InputEventKey).key_label == 0 and (input_slots[i] as InputEventKey).keycode == 0):
				input_button.text = "..."
		elif(input_slots[i] is InputEventJoypadButton or input_slots[i] is InputEventJoypadMotion or input_slots[i] is InputEventMouseButton):
			# input_button = TextureButton.new()
			var button_texture : TextureRect = TextureRect.new()
			button_texture.texture = _get_input_texture(input_slots[i])
			button_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			button_texture.stretch_mode = TextureRect.STRETCH_SCALE
			button_texture.size.x = keyxplorer_input_list.button_texture_size
			button_texture.size.y = keyxplorer_input_list.button_texture_size
			button_texture.position.x = (keyxplorer_input_list.input_button_size - keyxplorer_input_list.button_texture_size) / 2
			button_texture.position.y = (keyxplorer_input_list.input_button_size - keyxplorer_input_list.button_texture_size) / 2
			button_texture.mouse_filter = Control.MOUSE_FILTER_IGNORE
			input_button.add_child(button_texture)
			#input_button.texture_normal = _get_input_texture(input_slots[i])
			#input_button.ignore_texture_size = true
			#input_button.stretch_mode = TextureButton.STRETCH_SCALE
		else:
			# push_warning("Invalid input in " + keyxplorer_input.input_name + " at Slot " + str(i + 1) + ".\nSlots can be filled only by InputEventKey, InputEventMouseButton, InputEventJoypadButton or InputEventJoypadMotion.")
			# input_button = Button.new()
			input_button.text = "..."
			
		input_button.size_flags_vertical = Control.SIZE_EXPAND_FILL
		input_button.custom_minimum_size.x = keyxplorer_input_list.input_button_size
		input_button.button_up.connect(Callable(func() -> void:
			if(input_slot_edit != null): return
			input_slot_edit = InputSlotEdit.new()
			input_slot_edit.input_name = keyxplorer_input.input_name
			match i:
				0:
					input_slot_edit.slot = KXMap.KXInputSlot.SLOT_1
				1:
					input_slot_edit.slot = KXMap.KXInputSlot.SLOT_2
				2:
					input_slot_edit.slot = KXMap.KXInputSlot.SLOT_3
				3:
					input_slot_edit.slot = KXMap.KXInputSlot.SLOT_4
		))
		add_child(input_button)
		
func _input(event: InputEvent) -> void:
	if(input_slot_edit == null): return
	if(event is InputEventMouseMotion): return
	_remap_input(event)
		
# Wrapper for Keyxplorer.keyxplorer_map.remap_input().
# Calls Keyxplorer.keyxplorer_map.remap_input and emits a signal so the KXInputList knows that it must reload the UI.
func _remap_input(event : InputEvent) -> void:
	Keyxplorer.keyxplorer_map.remap_input(input_slot_edit.input_name, input_slot_edit.slot, event)
	Keyxplorer.reload()
	input_slot_edit = null
	input_remapped.emit()
	
# Returns the input texture configured in the parent KXInputList.input_textures.
# Only returns textures for InputEventMouseButton, InputEventJoypadButton and InputEventJoypadMotion.
# Keyboard keys show as text in the button.
func _get_input_texture(input : InputEvent) -> CompressedTexture2D:
	# Mouse buttons
	if(input is InputEventMouseButton):
		match input.button_index:
			MOUSE_BUTTON_LEFT:
				return input_textures.mouse_left_click
			MOUSE_BUTTON_MIDDLE:
				return input_textures.mouse_middle_click
			MOUSE_BUTTON_RIGHT:
				return input_textures.mouse_right_click
			MOUSE_BUTTON_WHEEL_UP:
				return input_textures.mouse_wheel_up
			MOUSE_BUTTON_WHEEL_DOWN:
				return input_textures.mouse_wheel_down
	# Joystick movement and Left/Right triggers (L2/R2)
	elif(input is InputEventJoypadMotion):
		match input.axis:
			JOY_AXIS_LEFT_X: 
				# Needs extra checking to know axis direction
				if(input.axis_value < 0):
					return input_textures.joystick_left_left
				else:
					return input_textures.joystick_left_right
			JOY_AXIS_LEFT_Y: 
				# Needs extra checking to know axis direction
				if(input.axis_value < 0):
					return input_textures.joystick_left_down
				else:
					return input_textures.joystick_left_up
			JOY_AXIS_RIGHT_X: 
				# Needs extra checking to know axis direction
				if(input.axis_value < 0):
					return input_textures.joystick_right_left
				else:
					return input_textures.joystick_right_right
			JOY_AXIS_RIGHT_Y: 
				# Needs extra checking to know axis direction
				if(input.axis_value < 0):
					return input_textures.joystick_right_down
				else:
					return input_textures.joystick_right_up
			JOY_AXIS_TRIGGER_LEFT:
				return input_textures.joystick_l_2
			JOY_AXIS_TRIGGER_RIGHT:
				return input_textures.joystick_r_2
	# Joystick buttons
	elif(input is InputEventJoypadButton):
		match input.button_index:
			JOY_BUTTON_A:
				return input_textures.joystick_button_down
			JOY_BUTTON_B:
				return input_textures.joystick_button_right
			JOY_BUTTON_X:
				return input_textures.joystick_button_left
			JOY_BUTTON_Y:
				return input_textures.joystick_button_up
			JOY_BUTTON_BACK:
				return input_textures.joystick_select
			JOY_BUTTON_GUIDE:
				return input_textures.joystick_home
			JOY_BUTTON_START:
				return input_textures.joystick_start
			JOY_BUTTON_LEFT_STICK:
				return input_textures.joystick_l_3
			JOY_BUTTON_RIGHT_STICK:
				return input_textures.joystick_r_3
			JOY_BUTTON_LEFT_SHOULDER:
				return input_textures.joystick_l_1
			JOY_BUTTON_RIGHT_SHOULDER:
				return input_textures.joystick_r_1
			JOY_BUTTON_DPAD_UP:
				return input_textures.joystick_dpad_up
			JOY_BUTTON_DPAD_DOWN:
				return input_textures.joystick_dpad_down
			JOY_BUTTON_DPAD_RIGHT:
				return input_textures.joystick_dpad_right
			JOY_BUTTON_DPAD_LEFT:
				return input_textures.joystick_dpad_left
			JOY_BUTTON_MISC1:
				return input_textures.joystick_capture
	return input_textures.unknown
