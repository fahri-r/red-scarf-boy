extends Control


func _on_MainMenu_pressed():
	Sound.play("click")
	LevelChanger.change_scene("res://scene/menu/MainMenu.tscn")
