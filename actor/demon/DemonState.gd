extends StateMachine

func _ready():
	add_state("idle")
	add_state("walk")
	add_state("attack")
	add_state("died")
	call_deferred("set_state", states.idle)

func _state_logic(delta):
	parent._apply_gravity(delta)
	parent._apply_movement()

func _get_transition(_delta):
	match state:
		states.idle:
			if parent.velocity.x != 0:
				return states.walk
			elif parent.attack_detector.is_colliding():
				return states.attack
			elif parent.died == true:
				return states.died
		states.walk:
			if parent.velocity.x == 0:
				return states.idle
			elif parent.attack_detector.is_colliding():
				return states.attack
			elif parent.died == true:
				return states.died
		states.attack:
			if parent.velocity.x != 0:
				return states.walk
			elif !parent.attack_detector.is_colliding():
				return states.idle
			elif parent.died == true:
				return states.died
	return null

func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			parent.animation.play("idle")
		states.walk:
			parent.animation.play("walk")
		states.attack:
			parent.animation.play("attack")
		states.died:
			parent.animation.play("died")

func _exit_state(old_state, new_state):
	pass
