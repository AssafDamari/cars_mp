extends Camera

# Controls how fast the camera moves

export var lerp_speed = 9.5
#var MOUSE_SENSITIVITY = 1
var selected_offset = 0
var offset = []

# Get a reference to the character this controller is controlling
onready var character : Character = owner.get_parent()
# Head shape is used to attach the camera
onready var target : Spatial = character.get_node("car_mesh")
var next_checkpoint = Vector3(0, 0, 0)
onready var arrow = $arrorw
onready var cone1 = $arrorw/cone

func _ready():

	SignalManager.connect("checkpoint_reached", self , "_on_checkpoint_reached")
	# ask first checkpoint for initial position
	SignalManager.emit_signal("first_checkpoint_request")
	SignalManager.connect("start_race", self, "start_race")
	
func _process(_delta):
	arrow.look_at(next_checkpoint, Vector3.UP)
	if angle_to_signed() > 90:
		cone1.material_override.albedo_color = Color.red
	else:
		cone1.material_override.albedo_color = Color.green	
	
func _physics_process(delta):
	
	# If there's no target, don't do anything
	if !target:
		return
	# Find the destination - target's position + the offset
	var _offset = offset[selected_offset] if offset.size() > 0 else Vector3.ZERO
	
	var target_pos = target.global_transform.translated(_offset)
	
	# Interpolate the current position with the destination
	global_transform = global_transform.interpolate_with(target_pos, lerp_speed * delta)
	# Always be pointing at the target and alittle up
	look_at(target.global_transform.origin + Vector3.UP, Vector3.UP)

	
func _on_checkpoint_reached(checkpoint_origin):
	if checkpoint_origin == null:
		arrow.visible = false
	else:	
		next_checkpoint = checkpoint_origin

func angle_to_signed():
	var camera_facing = global_transform.basis.z.normalized()
	var arrow_facing = arrow.global_transform.basis.z.normalized()
	var _angle = rad2deg(camera_facing.angle_to(arrow_facing))
	return _angle
	
func start_race():
	arrow.visible = true
	SignalManager.emit_signal("first_checkpoint_request")

func _input(ev):
	if Input.is_action_just_pressed("camera_pos"):
		selected_offset = (selected_offset + 1) % offset.size()
		#if offset[selected_offset].distance_to(target.global_transform.origin) < 10 :
		#lerp_speed = 30 * (1/offset[selected_offset].distance_to(target.global_transform.origin))

