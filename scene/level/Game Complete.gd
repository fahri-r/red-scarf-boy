extends Area2D

func _on_Level_Complete_body_entered(player):
	var enemy_total = 0
	if get_parent().has_node("Enemy"):
		for demon in get_parent().get_node("Enemy").get_children():
			enemy_total += 1
	
	if enemy_total == 0:
		var now_level = int(get_parent().name.right(5))
		SaverandLoader.custom_data.completed_level = now_level + 1
		SaverandLoader.save_game()
		player.emit_signal("game_complete")
		player.sword_hide = true
	else:
		player.emit_signal("level_not_complete")
