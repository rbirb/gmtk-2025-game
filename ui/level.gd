extends Control

@onready var anim_appear := $AnimationAppear

func appear():
	anim_appear.play("appear")

func disappear():
	anim_appear.play("disappear")
