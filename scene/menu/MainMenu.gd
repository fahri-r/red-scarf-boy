extends Control

func _ready():
	VisualServer.set_default_clear_color(Color.black)

func _on_StartButton_pressed():
	LevelChanger.change_scene("res://scene/World.tscn")

func _on_QuitButton_pressed():
	get_tree().quit()
