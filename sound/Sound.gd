extends Node

var sounds_path = "res://sound/"

var sounds = {
	"click" : load(sounds_path + "click.wav"),
	"hit_player" : load(sounds_path + "hit_player.wav"),
	"hit_enemy" : load(sounds_path + "hit_enemy.wav"),
	"attack" : load(sounds_path + "attack.wav"),
	"jump" : load(sounds_path + "jump.wav"),
	"sword" : load(sounds_path + "sword.wav"),
	"footstep" : load(sounds_path + "footstep.ogg")
}

onready var sound_players = get_children()

func play(sound_string, pitch_scale = 1, volume_db = 0):
	for soundPlayer in sound_players:
		if not soundPlayer.playing:
			soundPlayer.pitch_scale = pitch_scale
			soundPlayer.volume_db = volume_db
			soundPlayer.stream = sounds[sound_string]
			soundPlayer.play()
			return
	print("Too many sounds playing at once")
