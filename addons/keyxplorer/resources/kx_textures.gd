@icon("ikx_textures.svg")
class_name KXTextures
## Resource to hold information about the textures of inputs that are not keys.
extends Resource

@export var unknown : CompressedTexture2D = preload("res://addons/keyxplorer/button_textures/tile_0031.png")

@export_group("Mouse inputs")
@export var mouse_left_click : CompressedTexture2D = preload("res://addons/keyxplorer/button_textures/tile_0077.png")
@export var mouse_middle_click : CompressedTexture2D = preload("res://addons/keyxplorer/button_textures/tile_0079.png")
@export var mouse_right_click : CompressedTexture2D = preload("res://addons/keyxplorer/button_textures/tile_0078.png")
@export var mouse_wheel_up : CompressedTexture2D = preload("res://addons/keyxplorer/button_textures/tile_0080.png")
@export var mouse_wheel_down : CompressedTexture2D = preload("res://addons/keyxplorer/button_textures/tile_0081.png")

@export_group("Joystick inputs")
# Dpad
@export var joystick_dpad_up : CompressedTexture2D = preload("res://addons/keyxplorer/button_textures/tile_0035.png")
@export var joystick_dpad_left : CompressedTexture2D = preload("res://addons/keyxplorer/button_textures/tile_0038.png")
@export var joystick_dpad_down : CompressedTexture2D = preload("res://addons/keyxplorer/button_textures/tile_0037.png")
@export var joystick_dpad_right : CompressedTexture2D = preload("res://addons/keyxplorer/button_textures/tile_0036.png")
# Buttons (A/B/Y/X)
@export var joystick_button_up : CompressedTexture2D = preload("res://addons/keyxplorer/button_textures/tile_0306.png")
@export var joystick_button_left : CompressedTexture2D = preload("res://addons/keyxplorer/button_textures/tile_0309.png")
@export var joystick_button_down : CompressedTexture2D = preload("res://addons/keyxplorer/button_textures/tile_0308.png")
@export var joystick_button_right : CompressedTexture2D = preload("res://addons/keyxplorer/button_textures/tile_0307.png")
# Left stick
@export var joystick_left_up : CompressedTexture2D = preload("res://addons/keyxplorer/button_textures/tile_0247.png")
@export var joystick_left_left : CompressedTexture2D = preload("res://addons/keyxplorer/button_textures/tile_0250.png")
@export var joystick_left_down : CompressedTexture2D = preload("res://addons/keyxplorer/button_textures/tile_0249.png")
@export var joystick_left_right : CompressedTexture2D = preload("res://addons/keyxplorer/button_textures/tile_0248.png")
# Right stick
@export var joystick_right_up : CompressedTexture2D = preload("res://addons/keyxplorer/button_textures/tile_0315.png")
@export var joystick_right_left : CompressedTexture2D = preload("res://addons/keyxplorer/button_textures/tile_0318.png")
@export var joystick_right_down : CompressedTexture2D = preload("res://addons/keyxplorer/button_textures/tile_0317.png")
@export var joystick_right_right : CompressedTexture2D = preload("res://addons/keyxplorer/button_textures/tile_0316.png")
# Control buttons
@export var joystick_start : CompressedTexture2D = preload("res://addons/keyxplorer/button_textures/tile_0701.png")
@export var joystick_select : CompressedTexture2D = preload("res://addons/keyxplorer/button_textures/tile_0700.png")
@export var joystick_capture : CompressedTexture2D = preload("res://addons/keyxplorer/button_textures/tile_0692.png")
@export var joystick_home : CompressedTexture2D = preload("res://addons/keyxplorer/button_textures/tile_0683.png")
# Triggers
@export var joystick_l_1 : CompressedTexture2D = preload("res://addons/keyxplorer/button_textures/tile_0657.png")
@export var joystick_l_2 : CompressedTexture2D = preload("res://addons/keyxplorer/button_textures/tile_0655.png")
@export var joystick_l_3 : CompressedTexture2D = preload("res://addons/keyxplorer/button_textures/tile_0254.png")
@export var joystick_r_1 : CompressedTexture2D = preload("res://addons/keyxplorer/button_textures/tile_0658.png")
@export var joystick_r_2 : CompressedTexture2D = preload("res://addons/keyxplorer/button_textures/tile_0656.png")
@export var joystick_r_3 : CompressedTexture2D = preload("res://addons/keyxplorer/button_textures/tile_0322.png")
