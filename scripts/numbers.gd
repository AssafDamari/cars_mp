extends Spatial

func show_digit(digit):
	for c in get_children():
		c.visible = false
		
	if digit > -1 and digit < get_child_count():
		get_child(digit).visible = true
