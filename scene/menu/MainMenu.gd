extends Control

func _ready():
	SaverandLoader.load_game()
	VisualServer.set_default_clear_color(Color.black)

func _on_StartButton_pressed():
	LevelChanger.change_scene("res://scene/World.tscn")

func _on_QuitButton_pressed():
	get_tree().quit()

func _on_SelectLevel_pressed():
	LevelChanger.change_scene("res://scene/menu/SelectLevelMenu.tscn")
	get_tree().paused = false

func _on_Credits_pressed():
	LevelChanger.change_scene("res://scene/menu/CreditsMenu.tscn")
