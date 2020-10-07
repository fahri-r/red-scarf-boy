extends StaticBody2D

const DAMAGE = 7

export(String, "UP", "DOWN") var spike

func _ready():
	var collision_up = $CollisionUp
	var sprite_up = $SpriteUp
	var collision_down = $CollisionDown
	var sprite_down = $SpriteDown
	
	if spike == "UP":
		collision_up.disabled = false
		sprite_up.visible = true
		collision_down.disabled = true
		sprite_down.visible = false
	elif spike == "DOWN":
		collision_down.disabled = false
		sprite_down.visible = true
		collision_up.disabled = true
		sprite_up.visible = false
