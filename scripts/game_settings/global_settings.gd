extends Node

signal mouse_sens_updated(value)
#VIDEO
func change_displayMode(toggle):
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	SettingsFile.game_data.full_screen_on =toggle
	SettingsFile.save_data()

func change_vsync(toggle):
	DisplayServer.VSYNC_ENABLED
	SettingsFile.game_data.vsync_on = toggle
	SettingsFile.save_data()



func update_brightness(value):
	emit_signal("brightness_updated",value)
	SettingsFile.game_data.brightness = value
	SettingsFile.save_data()

#AUDIO
func update_master_vol(bus_idx, vol): #-50 min slider
	AudioServer.set_bus_volume_db(bus_idx,vol)
	match bus_idx:
		0:
			SettingsFile.game_data.master_vol = vol
			SettingsFile.save_data()
		1:
			SettingsFile.game_data.music_vol = vol
			SettingsFile.save_data()
		2:
			SettingsFile.game_data.sfx_vol = vol
			SettingsFile.save_data()

func update_mouse_sens(value):
	emit_signal("mouse_sens_updated",value)
	SettingsFile.game_data.mouse_sens = value
	SettingsFile.save_data()
