extends Control

func _on_add_5_music_pressed() -> void:
	Options.music_volume += 5
	Options.set_volumes()

func _on_sub_5_music_pressed() -> void:
	Options.music_volume -= 5
	Options.set_volumes()

func _on_add_5_sounds_pressed() -> void:
	Options.sounds_volume += 5
	Options.set_volumes()

func _on_sub_5_sounds_pressed() -> void:
	Options.sounds_volume -= 5
	Options.set_volumes()
