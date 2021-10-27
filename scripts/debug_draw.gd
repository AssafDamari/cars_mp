extends Control

var camera
var lines_to_draw = []

func _ready():
	camera = get_viewport().get_camera()
	
func _draw():
	for line in lines_to_draw:
		var start = camera.unproject_position(line[0])
		var end = camera.unproject_position(line[0] + line[1])
		draw_line(start, end, Color.red, 10)
