extends Actor

var MainInstances = ResourceLoader.MainInstances

const DAMAGE = 18

onready var stats = $EnemyStats
onready var detector = $Detector
onready var down_detector = $Detector/DownDetector
onready var front_detector = $Detector/FrontDetector
onready var back_detector = $Detector/BackDetector
onready var attack_detector = $Detector/AttackDetector
onready var sprite = $AnimatedSprite
onready var animation = $AnimatedSprite/AnimationPlayer
onready var health_bar = $HealthBar
onready var hide_timer = $HealthBar/HideTimer

var died = false

func _apply_gravity(delta):
	velocity.y += gravity * delta

func _apply_movement():
	if back_detector.is_colliding():
		sprite.scale.x *= -1
		detector.scale.x *= -1
	
	velocity.y = move_and_slide(velocity, FLOOR_NORMAL).y

func can_walk() -> bool :
	return down_detector.is_colliding()

func _on_Attack():
	Sound.play("attack")
	MainInstances.Player._on_Demon_Attack()

func _on_FrontDetector_body_entered(_body):
	if !can_walk():
		velocity.x = 0
	else:
		velocity.x = speed.x * sprite.scale.x * DEMON_SPEED_SCALE

func _on_FrontDetector_body_exited(_body):
	velocity.x = 0

func _on_Player_Attack(_area):
	Sound.play("hit_enemy", 1, 10)
	stats.health -= MainInstances.Player.DAMAGE
	health_bar.show()
	hide_timer.start()

func _on_HideTimer_timeout():
	health_bar.hide()

func _on_EnemyStats_enemy_died():
	died = true
	back_detector.set_collision_mask_bit(0, false)
	front_detector.set_collision_mask_bit(0, false)
	attack_detector.set_collision_mask_bit(0, false)
	yield(get_tree().create_timer(2),"timeout")
	queue_free()

func step_sound():
	Sound.play("footstep", rand_range(0.6, 1.2), -17)
