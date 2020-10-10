extends Control

var MainInstances = ResourceLoader.MainInstances

func _ready():
	var buttons = get_node("VBoxContainer/CenterContainer/ButtonContainer").get_children()
	var completed_level = SaverandLoader.custom_data.completed_level
	
	if completed_level > 0:
		for button in buttons:
			button.disabled = false
			if button.name == str(completed_level):
				break

func _on_MainMenu_pressed():
	Sound.play("click")
	LevelChanger.change_scene("res://scene/menu/MainMenu.tscn")

func _on_1_pressed():
	Sound.play("click")
	LevelChanger.selectedLevel = "res://scene/level/Level 1.tscn"
	LevelChanger.load_scene("res://scene/World.tscn")

func _on_2_pressed():
	Sound.play("click")
	LevelChanger.selectedLevel = "res://scene/level/Level 2.tscn"
	LevelChanger.load_scene("res://scene/World.tscn")

func _on_3_pressed():
	Sound.play("click")
	LevelChanger.selectedLevel = "res://scene/level/Level 3.tscn"
	LevelChanger.load_scene("res://scene/World.tscn")

func _on_4_pressed():
	Sound.play("click")
	LevelChanger.selectedLevel = "res://scene/level/Level 4.tscn"
	LevelChanger.load_scene("res://scene/World.tscn")
