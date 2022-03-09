extends Spatial

onready var car_mesh = $car_mesh
onready var coins_label = $control/texture_rect/coins_label
onready var car_price_label = $control/texture_rect_2/car_price_label
onready var button_buy = $control/button_buy

var body_index = 0 
var cars_count = 0 

func _ready():
	cars_count = car_mesh.car_bodyes.size()
	load_car()
	coins_label.text = str(CoinsManager.get_current_coins())
	SignalManager.connect("coins_updated", self, "_on_coins_updated")
	
func load_car():
	var car_price = get_car_price()
	var available_coins = CoinsManager.get_current_coins()
	car_mesh.load_body(body_index)
	car_price_label.text = str(car_price)
	$control/button_buy.disabled = car_price > available_coins
	
func get_car_price():
	return (body_index + 1) * 100
		
func _on_button_next_pressed():
	body_index += 1
	
	if body_index >= cars_count:
		body_index = 0
		 
	load_car()

func _on_button_prev_pressed():
	body_index -= 1
	
	if body_index < 0:
		body_index = cars_count - 1
		 
	load_car()

func _on_button_buy_pressed():
	var car_price = get_car_price()
	var available_coins = CoinsManager.get_current_coins()
	if car_price > available_coins:
		print("not enugth coins")
		return
	
	set_player_car(body_index)
	CoinsManager.remove_coins(car_price)
		
func set_player_car(car_body_index):
	var info = InfoManager.load_player_info()
	info.car_body_index = car_body_index
	InfoManager.save_player_info(info)
#	SignalManager.emit_signal("car_body_index_updated", info.coins)
	
func get_player_car():
	var info = InfoManager.load_player_info()
	return info.car_body_index
		
func _on_button_back_to_menu_pressed():
	get_tree().change_scene("res://scenes/main.tscn")


func _on_coins_updated(coins):
	coins_label.text = str(coins)
