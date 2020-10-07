extends Area2D

export (String, FILE, "*.tscn") var level_scene

func _on_Level_Complete_body_entered(player):
	var now_level = int(get_parent().name.right(5))
	SaverandLoader.custom_data.completed_level = now_level + 1
	SaverandLoader.save_game()
	player.emit_signal("level_complete", self)
