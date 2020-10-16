extends Control

var PlayerStats = ResourceLoader.PlayerStats

func _ready():
	SaverandLoader.load_game()
	VisualServer.set_default_clear_color(Color.black)

func _on_StartButton_pressed():
	Sound.play("click")
	LevelChanger.change_scene("res://scene/World.tscn")
	PlayerStats.refill_stats()

func _on_QuitButton_pressed():
	Sound.play("click")
	get_tree().quit()

func _on_SelectLevel_pressed():
	Sound.play("click")
	LevelChanger.change_scene("res://scene/menu/SelectLevelMenu.tscn")
	get_tree().paused = false

func _on_Credits_pressed():
	Sound.play("click")
	LevelChanger.change_scene("res://scene/menu/CreditsMenu.tscn")
