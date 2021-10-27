extends Node

var powerups = []

func init_pickups():
	
	powerups.append(
		powerup_data.new(
			"res://scenes/cannon_ball.tscn", 
			"res://scenes/cannot_ball_mesh.tscn", 
			"res://textures/bomb_thumb.png", 
			5
			))

	powerups.append(
		powerup_data.new(
			"res://scenes/rocket.tscn", 
			"res://scenes/missile_mesh.tscn", 
			"res://textures/missile_thumb.png", 
			5
			))

	powerups.append(
		powerup_data.new(
			"res://scenes/booster.tscn", 
			"res://scenes/booster_mesh.tscn", 
			"res://textures/booster_thumb.png", 
			1
			))	

	# only server should init pickupds
	if get_tree().get_network_unique_id() == 1:
		for p in get_children():
			randomize()
			powerups.shuffle()
			# after array shuffle 0  will be random pickup 
			p.init_pickup(powerups[0])
	else:
		# send request for server to send me back pickups it initialized 
		rpc_id(1, "request_pickup_data")
	
remote func request_pickup_data():
	var pickups_data = get_pickups_data()
	rpc_id(get_tree().get_rpc_sender_id(), "update_pickups", pickups_data)
	
func get_pickups_data():
	var pickups = []
	for p in get_children():
		pickups.append(p.pickup_data)
	return pickups
	
remote func update_pickups(pickups_data):
	var _pickups = get_children()
	for i in _pickups.size():
		_pickups[i].init_pickup(pickups_data[i])
