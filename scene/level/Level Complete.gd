extends Area2D

export (String, FILE, "*.tscn") var level_scene

func _on_Level_Complete_body_entered(player):
	player.emit_signal("level_complete", self)
