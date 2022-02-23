extends Spatial

var powerups = []

func init_pickups():
	
	powerups.append(
		powerup_data.new(
			"res://scenes/cannon_ball.tscn", 
			"res://scenes/cannot_ball_mesh.tscn", 
			"res://textures/bomb_thumb.png", 
			16
			))

	powerups.append(
		powerup_data.new(
			"res://scenes/rocket.tscn", 
			"res://scenes/missile_mesh.tscn", 
			"res://textures/missile_thumb.png", 
			8
			))

	powerups.append(
		powerup_data.new(
			"res://scenes/booster.tscn", 
			"res://scenes/booster_mesh.tscn", 
			"res://textures/booster_thumb.png", 
			1
			))	
	
	powerups.append(
		powerup_data.new(
			"res://scenes/boom_radius.tscn", 
			"res://scenes/boom_radius_mesh.tscn", 
			"res://textures/smoke_08.png",
			1
			))
			
	# only server should init pickupds
	if get_tree().is_network_server():
		for p in get_children():
			randomize()
			powerups.shuffle()
			# after array shuffle 0  will be random pickup 
			p.init_pickup(powerups[0])
	else:
		var _pickups = get_children()
		for i in _pickups.size():
			_pickups[i].init_pickup(null)
