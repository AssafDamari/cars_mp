extends Spatial

var is_active = true

func _ready():
	$win_particles.emitting = false

func _on_area_body_entered(body):
	if body.owner == null or not body.owner is Character:
		return
	
	if body.owner.controller_is_player:
		var info = InfoManager.load_player_info()
		info.coins += 1
		InfoManager.save_player_info(info)
		SignalManager.emit_signal("coins_updated", info.coins)
		$audio_stream_player_3d.play()
	$win_particles.emitting = true
	hide()

func hide():
	toggle()

func show():
	$win_particles.emitting = false
	toggle()
	
func toggle():
	is_active = !is_active
	$coin_mesh.visible = is_active
	$area/collision_shape.disabled = !is_active
	
func show_if_hidden():
	if not is_active:
		show()

