extends Path

var child_scene = "res://scenes/arrow_sign.tscn"


func _ready():
#	$path_follow.offset = 0
#	var child_instance = load(child_scene).instance()
#	add_child(child_instance)
#	child_instance.global_transform = $path_follow.global_transform

	for point in curve.get_baked_points():
		var child_instance = load(child_scene).instance()
		child_instance.global_transform.origin = point
		self.add_child(child_instance)
