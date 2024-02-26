extends Camera2D

var _bufferX = 0

func _ready():
	update_global_position()
	$PauseScreen/Button.connect("button_down",openthatthing)
#THIS SHOULD NOT BE HEREREeEE
func openthatthing():
	$uiContainer.visible=true
	
func _physics_process(delta):
	update_global_position()
	
	var player_direction = $"../PlayerContainer/Player".player_direction
	
	if player_direction == 1:
		_bufferX = 300
	if player_direction == -1:
		_bufferX = -300
		
	var XtoPlayer = (Global.PlayerX - position.x) * 0.1
	var YtoPlayer = (Global.PlayerY - position.y) * 0.1
	
	position.x +=  XtoPlayer + (Global.PlayerX + _bufferX - position.x) * 0.1
	position.y +=  YtoPlayer
	
func update_global_position():
	Global.CameraX = global_position.x
	Global.CameraY = global_position.y
