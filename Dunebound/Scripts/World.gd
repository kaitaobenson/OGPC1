extends Node2D

#Whatever you want to do at the beginning ig?

func _ready():
	Global.fader.set_modulate_a(1)
	Global.fader.fade_out()

func _process(delta):
	pass
