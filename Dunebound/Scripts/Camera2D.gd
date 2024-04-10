extends Camera2D

var _bufferX = 0

func _init():
	Global.camera = self

func _ready():
	$PauseScreen/Button.connect("button_down",openthatthing)

#THIS SHOULD NOT BE HEREREeEE
func openthatthing():
	$uiContainer.visible=true
	
func _physics_process(delta):
	var player_direction = Global.Player.player_sprite_direction
	
	if player_direction == 1:
		_bufferX = 300
	if player_direction == -1:
		_bufferX = -300
	if player_direction == 0:
		_bufferX = 0
	var XtoPlayer = (Global.Player.global_position.x - position.x) * 0.1
	var YtoPlayer = (Global.Player.global_position.y - position.y) * 0.1
	
	position.x +=  XtoPlayer + (Global.Player.global_position.x + _bufferX - position.x) * 0.1
	position.y +=  YtoPlayer