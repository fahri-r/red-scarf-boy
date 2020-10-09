extends Control

func _ready():
	if !get_parent().name == "UI":
		$BlackOverlay.visible = false
		$ParallaxBackground/Cloud.visible = true
		$ParallaxBackground/Grass.visible = true
		$ParallaxBackground/Mountain.visible = true
		$ParallaxBackground/Sky.visible = true

func _on_NewGame_pressed():
	LevelChanger.change_scene("res://scene/World.tscn")
	get_tree().paused = false

func _on_QuitGame_pressed():
	get_tree().quit()

func _on_MainMenu_pressed():
	LevelChanger.change_scene("res://scene/menu/MainMenu.tscn")
	get_tree().paused = false

func _on_SelectLevel_pressed():
	LevelChanger.change_scene("res://scene/menu/SelectLevelMenu.tscn")
	get_tree().paused = false
