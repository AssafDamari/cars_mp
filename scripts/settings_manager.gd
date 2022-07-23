extends Node


func get_settings():
	var info = InfoManager.load_player_info()
	return info.get("settings", InfoManager.default_info.settings)

func set_settings(settgins_to_add):
	var info = InfoManager.load_player_info()
	info.settings = settgins_to_add
	InfoManager.save_player_info(info)


