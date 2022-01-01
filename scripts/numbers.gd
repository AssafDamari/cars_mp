extends Spatial

func show_digit(digit):
	for c in get_children():
		c.visible = false
		
	if digit > -1:
		get_child(digit).visible = true
