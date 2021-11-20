extends Camera

# Controls how fast the camera moves
export var lerp_speed = 7.0
#var MOUSE_SENSITIVITY = 1
var offset = Vector3(0, 5, 9)
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
	
func _process(delta):
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
	var target_pos = target.global_transform.translated(offset)
	# Interpolate the current position with the destination
	global_transform = global_transform.interpolate_with(target_pos, lerp_speed * delta)
	# Always be pointing at the target
	look_at(target.global_transform.origin, Vector3.UP)
	
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
	
#func _input(event):
#	# If we are moving the mouse and mouse is captured within the window
#	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
#		# Rotate the head shape. Camera copies it's rotation.
#		head.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY * -0.05))
#		# Clamp rotation of the head on X axis
#		var head_rotation = head.rotation_degrees
#		head_rotation.x = clamp(head_rotation.x, -80, 80)
#		head.rotation_degrees = head_rotation
#		# Rotate the body of the character
#		#character.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -0.05))

