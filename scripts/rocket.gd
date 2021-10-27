extends KinematicBody

var exploation_force_factor = 20
var speed = 100
const exploitationPrefab = preload("res://scenes/exploitation.tscn")
var direction = Vector3()

func _ready():
	set_as_toplevel(true)
	direction = -get_parent().global_transform.basis.z.normalized()
	global_transform.origin.y -= 1
	
func _physics_process(delta):
	move_and_collide(direction * speed * delta)

func apply_force_and_damage_on_overlapping_bodies():
	var overlapping_bodies = $area.get_overlapping_bodies()
	for body in overlapping_bodies:
		if body is RigidBody:
			var impulse_direction = (body.global_transform.origin - global_transform.origin).normalized()
			body.add_force(global_transform.origin, Vector3.UP * exploation_force_factor)
			if body.get_owner().has_method("take_damage"):
				body.get_owner().take_damage()

func _on_area_body_entered(body):
	if body.name != "rocket":
		add_exploitation()
		apply_force_and_damage_on_overlapping_bodies()
		queue_free()

func add_exploitation():
	var exploitation = exploitationPrefab.instance()
	exploitation.global_transform = global_transform
	get_tree().root.add_child(exploitation)
