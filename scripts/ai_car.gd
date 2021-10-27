extends KinematicBody

export var speed = 5

var velocity = Vector3.ZERO
var gravity = 20

func _ready():
	$timer.connect("timeout", self, "_rpc_update_network")
	
func _physics_process(delta):
	# only server is moving ai cars and is responsible for update network
	if not get_tree().is_network_server():
		return
	
	velocity.y -= gravity * delta
	velocity.z = speed
	velocity = move_and_slide(velocity, Vector3.UP)

	
func _rpc_update_network():

	# RPC unreliable is faster but doesn't verify whether data has arrived or is intact
	rpc_unreliable("network_update", global_transform)

remote func network_update(transform):
	global_transform = transform
