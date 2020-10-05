extends Node

signal enemy_died
signal enemy_health_changed(value)

export(int) var max_health = 50
onready var health = max_health setget set_health

func set_health(value):
	health = clamp(value, 0, max_health)
	emit_signal("enemy_health_changed", health)
	if health == 0:
		emit_signal("enemy_died")
