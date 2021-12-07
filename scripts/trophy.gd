extends Spatial


func activate_trophy():
	$Cube.visible = true
	$animation_player.play("spin")
	$win_particles.emitting = true

func reset_trophy():
	$Cube.visible = false
	$animation_player.stop()
	$win_particles.emitting = false
