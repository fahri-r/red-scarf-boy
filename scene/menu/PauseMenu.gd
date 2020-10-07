extends Control

func _input(event):
	if event.is_action_pressed("pause"):
		var new_pause_state = ! get_tree().paused
		get_tree().paused = new_pause_state
		visible = new_pause_state

func _on_ResumeGame_pressed():
	get_tree().paused = false
	visible = false

func _on_QuitGame_pressed():
	get_tree().quit()

func _on_MainMenu_pressed():
	LevelChanger.change_scene("res://scene/menu/MainMenu.tscn")
	get_tree().paused = false


func _on_SelectLevel_pressed():
	LevelChanger.change_scene("res://scene/menu/SelectLevelMenu.tscn")
	get_tree().paused = false
