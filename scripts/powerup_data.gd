class_name powerup_data

var launcher_scene_path = ""
var scene_path = ""
var pickup_path = ""
var icon = ""
var count = 0

func _init(_scene_path, _pickup_path, _icon, _count, _launcher_scene_path):  
	self.scene_path = _scene_path
	self.pickup_path = _pickup_path
	self.icon = _icon
	self.count = _count
	self.launcher_scene_path = _launcher_scene_path

