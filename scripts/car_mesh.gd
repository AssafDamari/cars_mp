extends Spatial

onready var body = $body
onready var wheel_front_right = $wheel_front_right
onready var wheel_front_left = $wheel_front_left
onready var wheel_back_right = $wheel_back_right
onready var wheel_back_left = $wheel_back_left
var rotate_by = 0

var car_bodyes = [	
	"res://scenes/american_body.tscn", 
	"res://scenes/jeep_body.tscn",
	"res://scenes/truck_body3.tscn",
	"res://scenes/cyber_truck.tscn",
	"res://scenes/sedan_body.tscn",
	"res://scenes/sedan_body2.tscn",
	"res://scenes/sedan_body3.tscn",
	"res://scenes/police_body.tscn",
	"res://scenes/formula1_red.tscn",
	"res://scenes/buggy1.tscn",
	"res://scenes/buggy2.tscn",
	"res://scenes/buggy3.tscn"
	]
					
func load_body(body_index):
	# remove previus bodies if any
	for child in body.get_children():
		body.remove_child(child)
	# instance body by index
	body.add_child(load(car_bodyes[body_index]).instance())
	
func set_wheels_state(rotate_input, speed_input):
	var dir = -1 if speed_input < 0 else 1
	wheel_front_right.rotation.y = lerp(wheel_front_right.rotation.y, rotate_input * dir, 0.1) 
	wheel_front_left.rotation.y = lerp(wheel_front_left.rotation.y, rotate_input * dir, 0.1) 
	rotate_by = lerp(rotate_by, speed_input * 3, 0.1)
	
	wheel_front_right.rotation.x += rotate_by
	wheel_front_left.rotation.x += rotate_by
	wheel_back_right.rotation.x += rotate_by
	wheel_back_left.rotation.x += rotate_by
