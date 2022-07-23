extends Node

var info_file = "user://player_info.data"
var default_info = {
	"car_body_index": 0, 
	"coins" : 0,  
	"settings":{"bots_count" : 4}
	}

func load_player_info():
	var file = File.new()
	var _info = {}
	if file.file_exists(info_file):
		file.open(info_file, File.READ)
		_info = file.get_var()
		file.close()
	else:
		# set default info value
		_info = default_info
	return _info

func save_player_info(info_to_save):
	var file = File.new()
	file.open(info_file, File.WRITE)
	file.store_var(info_to_save)
	file.close()
