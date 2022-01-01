extends Spatial

onready var trophy = $Cube

func show_rank(rank):
	$animation_player.play("spin")
	if rank == 1:
		trophy.visible = true
		$win_particles.emitting = true
	else:
		$numbers.show_digit(rank)


func reset_trophy():
	trophy.visible = false
	$animation_player.stop()
	$win_particles.emitting = false
	$numbers.show_digit(-1)
