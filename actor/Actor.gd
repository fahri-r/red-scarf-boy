class_name Actor
extends KinematicBody2D

const FLOOR_NORMAL = Vector2.UP
const NORMAL_SPEED_SCALE = 1.0
const CROUCH_SPEED_SCALE = 0.3
const SLIDE_SPEED_SCALE = 1.2
const DEMON_SPEED_SCALE = 0.6
const DEMON_DAMAGE = 23

export var speed = Vector2(150.0, 350.0)

onready var gravity = ProjectSettings.get("physics/2d/default_gravity")

var velocity = Vector2.ZERO
