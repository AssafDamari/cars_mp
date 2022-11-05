extends Spatial

var powerups = []

func init_pickups():
	
	powerups.append(
		powerup_data.new(
			"res://scenes/cannon_ball.tscn",
			"res://scenes/cannot_ball_mesh.tscn", 
			"res://textures/bomb_thumb.png", 
			1,
			"res://scenes/cannon_ball_launcher.tscn"
			))

	powerups.append(
		powerup_data.new(
			"res://scenes/rocket.tscn", 
			"res://scenes/missile_mesh.tscn", 
			"res://textures/missile_thumb.png", 
			2,
			"res://scenes/cannon_ball_launcher.tscn"
			))

	powerups.append(
		powerup_data.new(
			"res://scenes/booster.tscn", 
			"res://scenes/booster_mesh.tscn", 
			"res://textures/booster_thumb.png", 
			1,
			"res://scenes/booster.tscn"
			))	
	
	powerups.append(
		powerup_data.new(
			"res://scenes/boom_radius.tscn", 
			"res://scenes/boom_radius_mesh.tscn", 
			"res://textures/boom_radius_thumb.png",
			1,
			"res://scenes/boom_radius.tscn"
			))
		
	powerups.append(
		powerup_data.new(
			"res://scenes/barrel_dropper.tscn", 
			"res://models/barrel.glb", 
			"res://textures/barrel_dropper.png",
			5,
			"res://scenes/barrel_dropper.tscn"
			))
				
	# only server should init pickupds
	if get_tree().is_network_server():
		for p in get_children():
			var random = RandomNumberGenerator.new()
			random.randomize()
			var rnd_index = random.randi_range(0, powerups.size() -1 )
			#powerups.shuffle()
			# after array shuffle 0  will be random pickup 
			p.init_pickup(powerups[rnd_index])
	else:
		var _pickups = get_children()
		for i in _pickups.size():
			_pickups[i].init_pickup(null)
