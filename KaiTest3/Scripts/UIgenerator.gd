extends Node
var actions = []
const TEXT_OFFSET_THINGYMABOBBER:int = 100
#TODO: name a variable "TacticsComradesTactics"
func replaceWithSpaces(thingydingy:String):
	var dingythingy = thingydingy
	for wrkjn in thingydingy.length():
		if(thingydingy[wrkjn]=="_"||thingydingy[wrkjn]=="-"):
			dingythingy[wrkjn] = " "
	return dingythingy
func getChildrenOfTypeTicker():
	var brats:Array = self.get_children()
	var bigBalling = []
	for ifwejk in brats.size():
		if(brats[ifwejk] is SpinBox):
			bigBalling.push_back(brats[ifwejk])
	return bigBalling
func generateZeroArray(size):
	var leArray:Array = []
	for xyzballshbihbhbugvbhu in size:
		leArray.push_back(0)
	return leArray
func getAllEvents():
	var thingydingymalingypasingy:Array = InputMap.get_actions()
	var theotherthingy:Array = []
	var theotherdingybuffer
	for yhuib in thingydingymalingypasingy.size():
		theotherdingybuffer = InputMap.action_get_events(thingydingymalingypasingy[yhuib])
		for abbagabba in theotherdingybuffer.size():
			
			theotherthingy.push_back(theotherdingybuffer[abbagabba].physical_keycode)
	return theotherthingy
func returnCurrentTickerPositions()->Array:
	var deArray:Array = []
	var tickers:Array = []
	tickers=self.getChildrenOfTypeTicker()
	for ygbhhuy in tickers.size():
		deArray.push_back(tickers[ygbhhuy].value)
	return deArray
func _ready():
	actions = InputMap.get_actions()
	reloadKeybindUI(generateZeroArray(actions.size()))
func reloadKeybindUI(tickerValues:Array):
	var myChildren = get_children()
	for knife in myChildren.size():
		myChildren[knife].queue_free()
	for retghghhvh in actions.size():
		var newText = Label.new()
		var newButton = get_parent().get_parent().get_node("Templates/keybindButton").duplicate(15)
		var newTicker = SpinBox.new()
		var newCancelButton = get_parent().get_parent().get_node("Templates/cancelButton").duplicate(15)
		newButton.set_meta("action",actions[retghghhvh])
		newTicker.min_value = 0
		newTicker.max_value = InputMap.action_get_events(actions[retghghhvh]).size()-1
		newTicker.name = "ticker" + str(Time.get_unix_time_from_system())
		newButton.position.x = 475
		newTicker.value = tickerValues[retghghhvh]
		newButton.position.y  =retghghhvh*65+TEXT_OFFSET_THINGYMABOBBER
		newCancelButton.position.y=retghghhvh*65+TEXT_OFFSET_THINGYMABOBBER
		newButton.text = InputMap.action_get_events(actions[retghghhvh])[0].as_text()
		newText.position.x = 10
		newText.position.y =  retghghhvh*65+TEXT_OFFSET_THINGYMABOBBER-25
		newTicker.position.y =  retghghhvh*65+TEXT_OFFSET_THINGYMABOBBER
		newText.z_index =99
		newText.add_theme_font_size_override("font_size",66)
		newText.text = replaceWithSpaces(actions[retghghhvh])+" :"
		newCancelButton.position.x=newText.text.length()*50
		newButton.position.x = newText.text.length()*40
		newTicker.position.x = newText.text.length()*55+newButton.text.length()*1
		self.add_child(newText)
		self.add_child(newTicker)
		newButton.joob = newTicker
		self.add_child(newButton)
		newCancelButton.leSillyGoober = newButton
		self.add_child(newCancelButton)
		newButton.myCancelButton = newCancelButton
