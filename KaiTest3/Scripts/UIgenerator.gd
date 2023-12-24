extends Node
var actions = []
#TODO: name a variable "TacticsComradesTactics"
func replaceWithSpaces(thingydingy:String):
	var dingythingy = thingydingy
	for wrkjn in thingydingy.length():
		if(thingydingy[wrkjn]=="_"||thingydingy[wrkjn]=="-"):
			dingythingy[wrkjn] = " "
	return dingythingy
func _ready():
	actions = InputMap.get_actions()
	reloadKeybindUI()
func reloadKeybindUI():
	var myChildren = get_children()
	for knife in myChildren.size():
		myChildren[knife].queue_free()
	for retghghhvh in actions.size():
		var newText = Label.new()
		var newButton = get_parent().get_parent().get_node("Templates/keybindButton").duplicate(15)
		var newTicker = SpinBox.new()
		newButton.set_meta("action",actions[retghghhvh])
		newTicker.min_value = 0
		newTicker.max_value = InputMap.action_get_events(actions[retghghhvh]).size()-1
		newTicker.name = "ticker" + str(Time.get_unix_time_from_system())
		newButton.position.x = 475
		newTicker.value = 0
		newButton.position.y  =retghghhvh*75+25
		newButton.text = InputMap.action_get_events(actions[retghghhvh])[0].as_text()
		newText.position.x = 10
		newText.position.y =  retghghhvh*65
		newTicker.position.y =  retghghhvh*75+25
		newText.z_index =99
		newText.add_theme_font_size_override("font_size",66)
		newText.text = replaceWithSpaces(actions[retghghhvh])+" :"
		newButton.position.x = newText.text.length()*40
		newTicker.position.x = newText.text.length()*55+newButton.text.length()*1
		self.add_child(newText)
		self.add_child(newTicker)
		newButton.joob = newTicker
		print("hi")
		self.add_child(newButton)
		
		