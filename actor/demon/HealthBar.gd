extends ProgressBar

func _ready():
	max_value = get_parent().find_node("EnemyStats").max_health
	value = get_parent().find_node("EnemyStats").max_health

func _on_enemy_health_changed(value):
	self.value = value
