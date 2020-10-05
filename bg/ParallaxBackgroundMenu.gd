extends ParallaxBackground

onready var sky = $Sky
onready var cloud = $Cloud
onready var mountain = $Mountain
onready var grass = $Grass

func _process(_delta):
	sky.motion_offset.x += 0.009
	cloud.motion_offset.x += 0.09
	mountain.motion_offset.x += 0.19
	grass.motion_offset.x += 0.29
