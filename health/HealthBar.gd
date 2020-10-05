extends ProgressBar

var PlayerStats = ResourceLoader.PlayerStats

func _ready():
	max_value = PlayerStats.max_health
	value = PlayerStats.max_health
	PlayerStats.connect("player_health_changed", self, "_on_player_health_changed")

func _on_player_health_changed(value):
	self.value = value
