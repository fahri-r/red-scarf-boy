extends Actor
class_name Player

var MainInstances = ResourceLoader.MainInstances
var PlayerStats = ResourceLoader.PlayerStats

signal level_complete
signal level_not_complete
signal game_complete
signal player_died
signal game_over

const FLOOR_DETECT_DISTANCE = 20.0
const INITIAL_DISTANCE = 100

const DAMAGE = 20

onready var sprite = $AnimatedSprite
onready var stand_collision = $StandCollision
onready var crouch_collision = $CrouchCollision
onready var slide_collision = $SlideCollision
onready var stand_hitbox = $HitBox/StandHitBox
onready var crouch_hitbox = $HitBox/CrouchHitBox
onready var slide_hitbox = $HitBox/SlideHitBox
onready var standing_area = $StandingArea
onready var attack_detector = $AttackDetector
onready var animation = $AnimatedSprite/AnimationPlayer
onready var invulnerability_timer = $InvulnerabilityTimer
onready var animation_effect = $AnimatedSprite/AnimationEffect
onready var platform_detector = $PlatformDetector

var speed_scale
var attacking = false
var sword_draw = true
var sword_hide = false
var died = false

func _ready():
	MainInstances.Player = self
	LevelChanger.connect("scene_changed", self, "_on_Level_change")
	PlayerStats.connect("player_died", self, "_on_PlayerStats_player_died")

func _exit_tree():
	MainInstances.Player = null
	

func _apply_gravity(delta):
	velocity.y += gravity * delta

func _apply_movement():
	var direction = get_direction()
	
	var is_jump_interrupted = Input.is_action_just_released("jump") and velocity.y < 0.0
	velocity = calculate_move_velocity(velocity, direction, speed, is_jump_interrupted)
	
	var is_on_platform = !platform_detector.is_colliding()
	
	var snap_vector = Vector2.DOWN * FLOOR_DETECT_DISTANCE if direction.y == 0.0 else Vector2.ZERO
	velocity = move_and_slide_with_snap(velocity, snap_vector, FLOOR_NORMAL, is_on_platform, 4, 0.9, false)
	
	if direction.x != 0:
		sprite.scale.x = 1 if direction.x > 0 else -1
		attack_detector.scale.y = 1 if direction.x > 0 else -1

func get_direction():
	if !died and !sword_draw and !sword_hide:
		var vel = Vector2()
		
		if !Input.is_action_pressed("slide"):
			vel.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		elif Input.is_action_pressed("slide"):
			if sprite.scale.x == 1:
				vel.x = 1
			else:
				vel.x = -1 
		
		vel.y = -1 if is_on_floor() and Input.is_action_just_pressed("jump") and can_stand() else 0
		
		return vel
	else:
		return Vector2.ZERO

func calculate_move_velocity(linear_velocity, direction, speed, is_jump_interrupted):
	var velocity = linear_velocity
	velocity.x = speed.x * direction.x * speed_scale
	
	if direction.y != 0.0:
		velocity.y = speed.y * direction.y
	
	if is_jump_interrupted:
		velocity.y *= 0.6
	
	return velocity

func _on_crouch():
	crouch_collision.disabled = false
	crouch_hitbox.disabled = false
	stand_collision.disabled = true
	stand_hitbox.disabled = true
	slide_collision.disabled = true
	slide_hitbox.disabled = true

func _on_stand():
	stand_collision.disabled = false
	stand_hitbox.disabled = false
	crouch_collision.disabled = true
	crouch_hitbox.disabled = true
	slide_collision.disabled = true
	slide_hitbox.disabled = true

func _on_slide():
	slide_collision.disabled = false
	slide_hitbox.disabled = false
	stand_collision.disabled = true
	stand_hitbox.disabled = true
	crouch_collision.disabled = true
	crouch_hitbox.disabled = true

func can_stand() -> bool:
	return standing_area.get_overlapping_bodies().empty()

func _on_Attack():
	Sound.play("attack")
	attack_detector.set_collision_layer_bit(5,true)
	yield(get_tree().create_timer(0.5), "timeout")
	attacking = false
	attack_detector.set_collision_layer_bit(5,false)

func _on_Demon_Attack():
	if invulnerability_timer.is_stopped():
		invulnerability_timer.start()
		Sound.play("hit_player")
		Sound.play("hit_enemy", 1, 10)
		PlayerStats.health -= DEMON_DAMAGE
		animation_effect.queue("invulnerability")

func _on_PlayerStats_player_died():
	died = true
	self.set_collision_layer_bit(0, false)
	yield(animation, "animation_finished")
	emit_signal("game_over")

func _on_InvulnerabilityTimer_timeout():
	animation_effect.play("rest")

func _on_HitBox_body_entered(body):
	if invulnerability_timer.is_stopped():
		invulnerability_timer.start()
		Sound.play("hit_player")
		Sound.play("hit_enemy", 1, 10)
		PlayerStats.health -= body.DAMAGE
		animation_effect.play("invulnerability")

func _on_Level_change():
	sword_draw = true
	animation_effect.play("rest")

func sword_sound():
	Sound.play("sword", 1, -8)

func step_sound():
	Sound.play("footstep", rand_range(0.6, 1.2), -12)
