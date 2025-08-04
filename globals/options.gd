# Settings Manager Global script
# Needed for menu's options
# ! do not add class_name, it's already global
extends Node
signal changed

var master_volume := AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
var sounds_volume := AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Sounds"))
var music_volume := AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
const MUTE_THRESHOLD := -52.0

func set_volumes():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), master_volume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sounds"), sounds_volume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), music_volume)
	if master_volume <= MUTE_THRESHOLD:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
	if sounds_volume <= MUTE_THRESHOLD:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Sounds"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Sounds"), false)
	if music_volume <= MUTE_THRESHOLD:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), false)
