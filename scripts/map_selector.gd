extends Control

var maps_bgs = [
	"res://textures/desert_map_bg.png",
	"res://textures/snow_map_bg.png",
	"res://textures/track_map_bg.png"
]

func _on_button_pressed():
		map_selected(0)


func _on_button_2_pressed():
	map_selected(1)


func _on_button_3_pressed():
	map_selected(2)	

func map_selected(map_index):
	SignalManager.emit_signal("map_selected", map_index)
	$texture_rect.texture = load(maps_bgs[map_index])
	
