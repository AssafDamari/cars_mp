extends Control

var current_countdown_number = 3
onready var counter_label = $center_container/label

func _ready():
	reset()

func start_countdown():
	counter_label.visible = true
	current_countdown_number = 3
	counter_label.text = str(current_countdown_number)	
	$timer.start()


func _on_timer_timeout():
	current_countdown_number -= 1
	if current_countdown_number < 1:
		counter_label.text = "GO!"
		SignalManager.emit_signal("countdown_finished", current_countdown_number)
	else:
		counter_label.text = str(current_countdown_number)	
		
	# make sure the "GO!" is visible by hiding and stopping in -1
	if current_countdown_number < 0:
		$timer.stop()
		counter_label.visible = false
		
	
	
func reset():
	current_countdown_number = 3
	counter_label.text = str(current_countdown_number)
	counter_label.visible = false	
