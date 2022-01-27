extends Path

var child_scene = "res://scenes/arrow_sign.tscn"


func _ready():
	for i in range(curve.get_point_count()):
		var child_instance = load(child_scene).instance()
		self.add_child(child_instance)
		child_instance.global_transform.origin = curve.get_point_position(i)
