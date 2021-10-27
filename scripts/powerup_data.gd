class_name powerup_data

var scene_path = ""
var pickup_path = ""
var icon = ""
var count = 0

func _init(scene_path, pickup_path, icon, count):  
   self.scene_path = scene_path
   self.pickup_path = pickup_path
   self.icon = icon
   self.count = count
