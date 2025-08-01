# Audio Managment Global Script
# To use write Audio.play_sound("path_to_sound_without_res://sounds/")
# to play sound from Any script of the game
extends Node

var current_song: AudioStreamPlayer = null
const SOUND_PATH := "res://sounds/"

func _process(_delta: float) -> void:
	if current_song != null:
		if !current_song.playing:
			current_song.play()

func play_song(song: String, volume_db:=0.0, fade:=false, fade_dur:=1.0):
	await stop_current_song(fade, fade_dur)
	current_song = AudioStreamPlayer.new()
	add_child(current_song)
	current_song.stream = load(SOUND_PATH+song)
	current_song.bus = "Music"
	if fade:
		current_song.volume_db = -62.0
		fade_volume(current_song, volume_db, fade_dur)
	else:
		current_song.volume_db = volume_db
	current_song.play()

func stop_current_song(fade:=true, fade_dur:=1.0):
	if current_song == null: return
	if fade:
		await fade_volume(current_song, -62.0, fade_dur)
	current_song.stop()
	current_song = null

func fade_volume(player: AudioStreamPlayer, to_volume: float, duration: float):
	var tween = create_tween()
	
	if player.volume_db > to_volume:
		tween.tween_property(player, "volume_db", to_volume, duration).from_current().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN)
	else:
		tween.tween_property(player, "volume_db", to_volume, duration).from_current().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	await tween.finished

func play_sound(sound: String, volume_db:=0.0, pitch_scale:=1.0, max_polyphony:=1, bus:="Sounds"):
	var soundinstance := AudioStreamPlayer.new()
	add_child(soundinstance)
	soundinstance.stream = load(SOUND_PATH+sound)
	soundinstance.bus = bus
	soundinstance.volume_db = volume_db
	soundinstance.pitch_scale = pitch_scale
	soundinstance.max_polyphony = max_polyphony
	
	soundinstance.play()
	await soundinstance.finished
	soundinstance.queue_free()

func play_random_sound(path: String, volume_db:=0.0, pitch_scale:=1.0, max_polyphony:=1, bus:="Sounds"):
	var dir := DirAccess.open(SOUND_PATH+path)
	assert(dir == null, "play_random_sound: Could not open folder")
	dir.list_dir_begin()
	var files: Array[String]
	for file: String in dir.get_files():
		files.append(SOUND_PATH + path + "/" + file)
	play_sound(files[randi_range(0,files.size()-1)], volume_db, pitch_scale, max_polyphony, bus)
