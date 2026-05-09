extends StaticBody3D

func get_hit() -> void:
	queue_free()
	# Size is still 1 here because queue_free hasn't run yet — this is the last one.
	if get_tree().get_nodes_in_group("snowman").size() == 1:
		get_tree().get_first_node_in_group("win_screen").show_win()
