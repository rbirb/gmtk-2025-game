extends Label

var finished = true
var time = 0.0
var time_to_current_score = 2.0
var a = false
var n

func act():
	a = true

func _process(delta):
	if finished and a:
		time += delta
		n = int(time / time_to_current_score * Global.score)
		Audio.play_score_up(-10.0, clamp(n / 0.001, 0.1, 60.0))
		text = str(n)
		if time >= time_to_current_score:
			a = false
			text = str(Global.score)

func reset():
	time = 0
	a = false
