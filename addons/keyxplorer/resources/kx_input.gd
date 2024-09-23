@icon("ikx_input.svg")
class_name KXInput
## Resource to contain information about inputs.
extends Resource

## Name to be shown in the UI when configuring the input. Can be the key of a CSV to be auto-translated.
@export var show_name : String = "Default KX"
## Internal name to access and compare the input.
@export var input_name : String = "kxi_"
## Input slot.
@export var slot_1 : InputEvent
## Input slot.
@export var slot_2 : InputEvent
## Input slot.
@export var slot_3 : InputEvent
## Input slot.
@export var slot_4 : InputEvent
