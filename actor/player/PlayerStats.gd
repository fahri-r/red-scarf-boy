extends Resource
class_name PlayerStats

var max_health = 100
var health = max_health setget set_health

signal player_health_changed(value)
signal player_died

func set_health(value):
	health = clamp(value, 0, max_health)
	emit_signal("player_health_changed", health)
	if health == 0:
		emit_signal("player_died")

func refill_stats():
	self.health = max_health
