extends CanvasLayer

var PlayerStats = ResourceLoader.PlayerStats

var selectedLevel = null

signal scene_changed()

onready var animation = $AnimationPlayer

func change_scene(path):
	yield(get_tree().create_timer(0.4),"timeout")
	animation.play("fade")
	yield(animation, "animation_finished")
	get_tree().change_scene(path)
	animation.play_backwards("fade")
	emit_signal("scene_changed")

func change_level(finish_area, parent):
	yield(get_tree().create_timer(0.4),"timeout")
	animation.play("fade")
	yield(animation,"animation_finished")
	PlayerStats.refill_stats()
	parent.currentLevel.queue_free()
	var NewLevel = load(finish_area.level_scene).instance()
	parent.add_child_below_node(parent.level,NewLevel)
	parent.player.position = NewLevel.get_node("Position2D").position
	animation.play_backwards("fade")
	emit_signal("scene_changed")

func load_scene(path):
	yield(get_tree().create_timer(0.4),"timeout")
	animation.play("fade")
	yield(animation, "animation_finished")
	get_tree().change_scene(path)
	
func load_level(path, parent):
	PlayerStats.refill_stats()
	parent.currentLevel.queue_free()
	var NewLevel = load(path).instance()
	parent.add_child_below_node(parent.level,NewLevel)
	parent.player.position = NewLevel.get_node("Position2D").position
	animation.play_backwards("fade")
	selectedLevel = null
