extends StateMachine

func _ready():
	add_state("idle")
	add_state("run")
	add_state("jump")
	add_state("fall")
	add_state("crouch")
	add_state("crawl")
	add_state("slide")
	add_state("attack")
	add_state("died")
	add_state("sword_draw")
	add_state("sword_hide")
	call_deferred("set_state", states.idle)

func _state_logic(delta):
	if [states.idle, states.run].has(state):
		parent.speed_scale = parent.NORMAL_SPEED_SCALE
	elif [states.crouch, states.crawl].has(state):
		parent.speed_scale = parent.CROUCH_SPEED_SCALE
	elif [states.slide].has(state):
		parent.speed_scale = parent.SLIDE_SPEED_SCALE
	parent._apply_gravity(delta)
	parent._apply_movement()

func _get_transition(delta):
	match state:
		states.idle:
			if !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif parent.velocity.x != 0:
				return states.run
			elif Input.is_action_pressed("crouch"):
				return states.crouch
			elif Input.is_action_pressed("slide") and !parent.sword_hide and !parent.sword_draw:
				return states.slide
			elif Input.is_action_just_pressed("attack") and !parent.attacking:
				return states.attack
			elif parent.died:
				return states.died
			elif parent.sword_draw:
				return states.sword_draw
			elif parent.sword_hide:
				return states.sword_hide
		states.run:
			if !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif parent.velocity.x == 0:
				return states.idle
			elif Input.is_action_pressed("crouch"):
				return states.crawl
			elif Input.is_action_pressed("slide"):
				return states.slide
			elif parent.died:
				return states.died
			elif parent.sword_draw:
				return states.sword_draw
			elif parent.sword_hide:
				return states.sword_hide
		states.jump:
			if parent.is_on_floor():
				return states.idle
			elif parent.velocity.y >= 0:
				return states.fall
			elif parent.died:
				return states.died
		states.fall:
			if parent.is_on_floor():
				return states.idle
			elif parent.velocity.y < 0:
				return states.jump
			elif parent.died:
				return states.died
		states.crouch:
			if !Input.is_action_pressed("crouch") and parent.can_stand():
				return states.idle
			elif !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				else:
					return states.fall
			elif parent.velocity.x != 0:
				return states.crawl
			elif Input.is_action_pressed("slide"):
				return states.slide
			elif parent.died:
				return states.died
			elif parent.sword_draw:
				return states.sword_draw
			elif parent.sword_hide:
				return states.sword_hide
		states.crawl:
			if !Input.is_action_pressed("crouch") and parent.can_stand():
				return states.run
			elif !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				else:
					return states.fall
			elif parent.velocity.x == 0:
				return states.crouch
			elif Input.is_action_pressed("slide"):
				return states.slide
			elif parent.died:
				return states.died
			elif parent.sword_draw:
				return states.sword_draw
			elif parent.sword_hide:
				return states.sword_hide
		states.slide:
			if !Input.is_action_pressed("slide"):
				if parent.can_stand():
					return states.idle
				else:
					return states.crouch
			elif !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				else:
					return states.fall
			elif parent.velocity.x == 0:
				if parent.can_stand():
					return states.idle
				else:
					return states.crouch
			elif parent.died:
				return states.died
			elif parent.sword_draw:
				return states.sword_draw
			elif parent.sword_hide:
				return states.sword_hide
		states.attack:
			if !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif parent.velocity.x == 0 and !parent.attacking:
				return states.idle
			elif parent.velocity.x != 0:
				return states.run
			elif Input.is_action_pressed("crouch"):
				return states.crawl
			elif Input.is_action_pressed("slide"):
				return states.slide
			elif parent.died:
				return states.died
		states.sword_draw:
			if !parent.sword_draw and parent.velocity.x == 0:
				return states.idle
		states.sword_hide:
			if !parent.sword_hide and parent.velocity.x == 0:
				return states.idle
	return null

func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			parent.animation.play("idle")
		states.run:
			parent.animation.play("run")
		states.jump:
			parent.animation.play("jump")
			Sound.play("jump")
		states.fall:
			parent.animation.play("fall")
		states.crouch:
			parent.animation.play("crouch")
			if old_state != states.crawl:
				parent._on_crouch()
		states.crawl:
			parent.animation.play("crawl")
			if old_state != states.crouch:
				parent._on_crouch()
		states.slide:
			parent.animation.play("slide")
			if old_state != states.slide:
				parent._on_slide()
		states.attack:
			parent.attacking = true
			parent.animation.play("attack2")
		states.died:
			parent.animation.play("died")
		states.sword_draw:
			parent.animation.play("sword draw")
			yield(parent.animation,"animation_finished")
			parent.sword_draw = false
		states.sword_hide:
			parent.animation.play("sword hide")
			yield(parent.animation,"animation_finished")
			parent.sword_hide = false

func _exit_state(old_state, new_state):
	match old_state:
		states.crouch:
			if new_state != states.crawl:
				parent._on_stand()
		states.crawl:
			if new_state != states.crouch:
				parent._on_stand()
		states.slide:
			if new_state != states.slide:
				if new_state != states.idle:
					parent._on_crouch()
				else:
					parent._on_stand()
		states.attack:
			if new_state != states.attack:
				parent.attacking = false
