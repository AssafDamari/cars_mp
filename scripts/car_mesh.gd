extends Spatial

onready var body = $body
var wheel_front_right
var wheel_front_left
var wheel_back_right
var wheel_back_left
var rotate_by = 0

var car_bodyes = [
	"res://scenes/sedan_body.tscn",
	"res://scenes/american_body.tscn", 
	"res://scenes/jeep_body.tscn",
	"res://scenes/sedan_body2.tscn",
	"res://scenes/truck_body3.tscn",
	"res://scenes/cyber_truck.tscn",
	"res://scenes/sedan_body3.tscn",
	"res://scenes/police_body.tscn",
	"res://scenes/duck1_car.tscn",
	"res://scenes/buggy2.tscn",
	"res://scenes/tractor_body.tscn",
	"res://scenes/formula1_red.tscn",
	"res://scenes/dragon_car.tscn"
	]
					
func load_body(body_index):
	# remove previus bodies if any
	for child in body.get_children():
		body.remove_child(child)
	# instance body by index
	var car_body = load(car_bodyes[body_index]).instance()
	body.add_child(car_body)
	wheel_front_right = car_body.find_node("wheel_front_right")
	wheel_front_left = car_body.find_node("wheel_front_left")
	
func set_wheels_state(rotate_input, speed_input):
	var dir = -1 if speed_input < 0 else 1
	if wheel_front_right:
		wheel_front_right.rotation.y = lerp(wheel_front_right.rotation.y, rotate_input * dir, 0.1) 
	if wheel_front_left:
		wheel_front_left.rotation.y = lerp(wheel_front_left.rotation.y, rotate_input * dir, 0.1) 

