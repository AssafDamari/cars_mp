extends Spatial

onready var body = $body

var car_bodyes = [	
	"res://scenes/american_body.tscn", 
	"res://scenes/american_body2.tscn", 
	"res://scenes/american_body3.tscn",
	"res://scenes/cyber_truck.tscn",
	"res://scenes/formula1_body.tscn",
	"res://scenes/formula1_body2.tscn",
	"res://scenes/formula1_body3.tscn",
	"res://scenes/jeep_body.tscn",
	"res://scenes/jeep_body2.tscn",
	"res://scenes/jeep_body3.tscn",
	"res://scenes/sedan_body.tscn",
	"res://scenes/sedan_body2.tscn",
	"res://scenes/sedan_body3.tscn",
	"res://scenes/truck_body.tscn",
	"res://scenes/truck_body2.tscn",
	"res://scenes/truck_body3.tscn",
	"res://scenes/police_body.tscn",
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
	
	
