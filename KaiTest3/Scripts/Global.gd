extends Node

var Player: Object
var camera: Camera2D
var saver_loader: Object

var TimeOfDay = 1
var DayCount = 1

var temperature
var elapsed_time: float

#???? What is this
var newFood

func _process(delta):
	elapsed_time += delta
	if temperature > 99 || temperature < 1:
		elapsed_time = 0


func texture(name:String):
	#make a texture, load an image into it, and return the texture!
	var image = Image.new()
	var texture = ImageTexture.new()
	image.load(name)
	texture.create_from_image(image)
	return texture

#run code from a string. yes, our codebase is about to get really bad really fast
func run_script(input):
	var what_is_wrong_with_me = RefCounted.new()
	var script = GDScript.new()
	script.set_source_code("func eval():" + input)
	script.reload()
	what_is_wrong_with_me.set_script(script)
	return what_is_wrong_with_me.eval()
