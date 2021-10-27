extends Node

func show_debug(str_to_print):
	get_tree().root.get_node("main").output_str(str_to_print)
