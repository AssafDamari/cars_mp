extends Controller
class_name Ai

var target_inedx = 0
var path;
var max_speed = 12
var target_radius = 12

onready var marker_target = $marker_target
onready var marke_forward = $marke_forward
onready var next_target_market = $next_target_market
onready var position_marker = $position_marker


# For type checking
func is_ai():
	return true
	
func _ready():
	randomize()
	character.speed = rand_range(5, max_speed)
	print(character.name, " speed ", character.speed)
	#if we have a path (should be given from main->map) set the first target
	if path:
		next_target_market.global_transform.origin = path.curve.get_point_position(target_inedx)
	
	#set target pos marker size
	next_target_market.mesh.radius = target_radius
	
func _process(_delta):
	
	
	character.cmd[0] = true # forward
#	character.cmd[0] = Input.is_action_pressed("forward")
#	character.cmd[1] = Input.is_action_pressed("backward")
#	character.cmd[2] = Input.is_action_pressed("left")
#	character.cmd[3] = Input.is_action_pressed("right")

	var target_pos = path.curve.get_point_position(target_inedx)
	marker_target.global_transform = character.car_mesh.global_transform
	marker_target.look_at(target_pos, Vector3.UP)

	marke_forward.global_transform = character.car_mesh.global_transform
	position_marker.global_transform = character.car_mesh.global_transform
	
	var target_dir = marker_target.global_transform.basis.z.normalized()
	var forward_dir = marke_forward.global_transform.basis.z.normalized()
	var _angle_to = rad2deg(forward_dir.angle_to(target_dir))
	
	if _angle_to > 15 :
		if forward_dir.cross(target_dir).dot(Vector3.UP) > 0:
			turn_left()
		else:
			turn_right()

	# if we are close to target, set next point as target
	if (target_pos - character.car_mesh.global_transform.origin).length() < target_radius:
		# set next point with modulo
		target_inedx = target_inedx + 1 if path.curve.get_baked_points().size() > target_inedx else target_inedx
		next_target_market.global_transform.origin = path.curve.get_point_position(target_inedx)
	
	
func turn_left():
	character.cmd[2] = true # left
	character.cmd[3] = false # right

func turn_right():
	character.cmd[2] = false # left
	character.cmd[3] = true # right
