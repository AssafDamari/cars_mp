extends Path

var child_scene = "res://scenes/arrow_sign.tscn"
onready var path_follow = $path_follow 

func _ready():
	var interval = curve.get_baked_length() / curve.get_point_count()
	for i in range(curve.get_point_count()):
		var child_instance = load(child_scene).instance()
		self.add_child(child_instance)
		path_follow.offset += interval
		child_instance.global_transform = path_follow.global_transform
		#child_instance.rotate_y(deg2rad(45.0))
