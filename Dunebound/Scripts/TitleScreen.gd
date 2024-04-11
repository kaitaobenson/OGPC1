extends Node2D

@export var do_display: bool = true

@onready var logo = $"Logo"
@onready var title_screen = $"MainScreen"

var displayed_logo: bool = false
var displayed_title_screen: bool = false

var logo_display_time: float = 1
var fade_time: float = 2


func _ready():
	if do_display:
		logo.visible = true
		logo.modulate.a = 0
		title_screen.visible = false
		
		await get_tree().create_timer(1).timeout
		await get_tree().create_tween().tween_property(logo, "modulate:a", 1, fade_time)
		await get_tree().create_timer(logo_display_time).timeout
		await get_tree().create_tween().tween_property(logo, "modulate:a", 0, fade_time)
		await get_tree().create_timer(4).timeout
		
		logo.free()
		title_screen.modulate.a = 0
		title_screen.visible = true
		await get_tree().create_tween().tween_property(title_screen, "modulate:a", 1, fade_time)
		
	else:
		get_tree().change_scene_to_file("res://Scenes/Main.tscn")
