extends Node2D

@export var gradientResource: Gradient
var color_value = 0

func _init():
	Global.temperature_ui = self

func _process(delta):
	color_value = Global.player_temp / 100.0
	print(color_value)
	modulate = gradientResource.sample(color_value)
