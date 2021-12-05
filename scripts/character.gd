
extends Spatial
class_name Character

# Node references
onready var ball = $Ball
onready var car_mesh = $car_mesh
onready var car_body = $car_mesh/body
onready var ground_ray = $car_mesh/ray_cast
onready var right_wheel = $car_mesh/wheel_front_right
onready var left_wheel = $car_mesh/wheel_front_left
onready var muzzle = $car_mesh/muzzle
onready var trails = $car_mesh/trails
onready var stuned_patricles = $car_mesh/stun_particle
onready var stun_timer = $stun_timer
onready var drift_sound = $car_mesh/drift_sound
onready var engine_sound = $car_mesh/engine_sound
## Commands
## An enum is used for readability
## Also a dictionary can be used
enum Command { FORWARD, BACKWARD, LEFT, RIGHT, JUMP, SPRINT, PRIMARY, SECONDARY }
var cmd = [false, false, false, false, false, false, false, false]

# Where to place the car mesh relative to the sphere
var sphere_offset = Vector3(0, -0.9, 0)
# Engine power
var acceleration = 70
# initial speed
var speed = 10
# Turn amount, in degrees
var steering = 1.0
# How quickly the car turns
var turn_speed = 3
# Below this speed, the car doesn't turn
var turn_stop_limit = 1
# Variables for input values
var speed_input = 0
var rotate_input = 0
var body_tilt = 110
var shooting_force_factor = 3
var controller_is_player = false
var controller_is_ai = false
var controller_is_peer = false
var powerup = null
var forces_to_apply = []
var my_body_index
var stuned = false
var next_checkpoint_index = 0

func _ready():
	#  We don’t want the RayCast to collide with the ball
	ground_ray.add_exception(ball)
	controller_is_player = $controller.has_method("is_player")
	controller_is_ai = $controller.has_method("is_ai")
	controller_is_peer = $controller.has_method("is_peer")	
	SignalManager.connect("start_race",self,"start_race")
	
	if controller_is_peer:
		ball.mode = RigidBody.MODE_KINEMATIC
		#set_physics_process(false)
	#else: # else means player
	#	$timer.connect("timeout", self, "_rpc_update_network")
	# choose car type
	if is_network_master():
		randomize()
		my_body_index = randi() % car_body.get_children().size()
		# regidter myself at server, he will update all
		rpc_id(1, "register_player", name, my_body_index)
		rpc_id(999, "register_player", "999", my_body_index)
	
func _physics_process(delta):
	
	if controller_is_peer:
		return
		
	# rotate the car mesh based on the rotation input smoothly
	if ball.linear_velocity.length() > turn_stop_limit:
		var new_basis = car_mesh.global_transform.basis.rotated(car_mesh.global_transform.basis.y, rotate_input)
		car_mesh.global_transform.basis = car_mesh.global_transform.basis.slerp(new_basis, turn_speed * delta)
		car_mesh.global_transform = car_mesh.global_transform.orthonormalized()
		# tilt body for effect
		var t = -rotate_input * ball.linear_velocity.length() / body_tilt
		car_mesh.rotation.z = lerp(car_mesh.rotation.z, t, 10 * delta)
	
	# Keep the car mesh aligned with the sphere
	car_mesh.transform.origin = ball.transform.origin + sphere_offset
	
	if cmd[Command.JUMP]:
		rpc("shoot")

	if ground_ray.is_colliding() and not stuned:
		# Accelerate based on car's forward direction
		ball.add_central_force(-car_mesh.global_transform.basis.z * speed_input)
		
	# add forces from collisions and exploations
	for f in forces_to_apply:
		ball.add_central_force(f)
	forces_to_apply = []
	
	# if we fall reset pos
	if car_mesh.global_transform.origin.y < -10:
		ball.set_mode(RigidBody.MODE_STATIC)
		ball.global_transform.origin = Vector3(0, 20, 0)
		ball.set_mode(RigidBody.MODE_RIGID)
	
	# change engine sound pich according to velocity
	engine_sound.pitch_scale = 1 + ball.linear_velocity.length() * delta
	
func _process(delta):
	set_trails()
	
	if controller_is_peer:
		return
	
	# Get accelerate/brake input
	speed_input = 0
	if cmd[Command.FORWARD]:
		speed_input += speed
	elif cmd[Command.BACKWARD]:
		speed_input -= speed
	speed_input *= acceleration
	
	# Get steering input
	rotate_input = 0
	if cmd[Command.LEFT]:
		rotate_input += .6
	elif cmd[Command.RIGHT]:
		rotate_input -= .6
		
	# revert steering for reverse
	rotate_input = rotate_input*-1 if speed_input < 0 else rotate_input
	rotate_wheels_mesh()
	align_with_slopes(delta)
	_rpc_update_network()
	
	
func rotate_wheels_mesh():
	# rotate wheels according to car movment direction
	var dir = -1 if speed_input < 0 else 1
	right_wheel.rotation.y = rotate_input * dir
	left_wheel.rotation.y = rotate_input * dir
	
	
func align_with_slopes(delta):
	var n = ground_ray.get_collision_normal()
	var xform = align_with_y(car_mesh.global_transform, n.normalized())
	car_mesh.global_transform = car_mesh.global_transform.interpolate_with(xform, 10 * delta)
	
	
func set_trails():
	var _emitting = abs(car_mesh.rotation.z)  > 0.1
	for trail in trails.get_children():
		trail.emitting = _emitting
	#play drift sound
	if _emitting:
		if !drift_sound.playing:
			drift_sound.play()
	else:
		drift_sound.stop()
		
		
func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform


func take_damage():
	rpc("take_damage_network")

sync func take_damage_network():
	stuned = true
	stuned_patricles.emitting = true
	stun_timer.start()
	
func equipt(powerup):
	if controller_is_player:
		# show pickup in ui for player
		SignalManager.emit_signal("ui_show_pickup", powerup)
		rpc ("equipt_network", powerup.scene_path, powerup.pickup_path, powerup.icon, powerup.count)


sync func equipt_network(scene_path, pickup_path, icon, count):
	self.powerup = powerup_data.new(scene_path, pickup_path, icon, count)


sync func shoot():
	if not self.powerup:
		return
	if self.powerup.count > 0:
		muzzle.add_child(load(self.powerup.scene_path).instance())
		self.powerup.count -= 1
		SignalManager.emit_signal("ui_show_pickup", self.powerup)
		if self.powerup.count == 0 :
			SignalManager.emit_signal("ui_show_pickup", null)
	else:
		self.powerup = null
		SignalManager.emit_signal("ui_show_pickup",null)


func _rpc_update_network():
	# RPC unreliable is faster but doesn't verify whether data has arrived or is intact
	rpc_unreliable("network_update", car_mesh.global_transform)


remote func network_update(car_mesh_transform):
	ball.global_transform.origin = car_mesh.global_transform.origin - sphere_offset
	car_mesh.global_transform = car_mesh_transform
	car_mesh.global_transform = car_mesh.global_transform.orthonormalized()


func _on_Ball_body_entered(body):
	if body.owner and body.owner.is_in_group("Characters"):
		rpc_id(int(body.owner.name), "applay_force_on_character", ball.linear_velocity * 0.01)
		

remote func applay_force_on_character(_vel):
	var _id = get_tree().get_network_unique_id()
	get_parent().get_node(str(_id)).forces_to_apply.append(_vel)


sync func register_player(player_name, body_index):
	RegisteredPlayers.data[player_name] = {"body_index": body_index}
	rpc("update_registered_players", RegisteredPlayers.data)


sync func update_registered_players(updated_registered_players):
	RegisteredPlayers.data = updated_registered_players
	for _character in get_parent().get_children():
		if RegisteredPlayers.data.has(_character.name):
			var body_index = RegisteredPlayers.data[_character.name]["body_index"]
			_character.get_node("car_mesh/body").get_child(body_index).visible = true
	
func _on_stun_timer_timeout():
	stuned = false
	stuned_patricles.emitting = false
	
func start_race():
	next_checkpoint_index = 0
