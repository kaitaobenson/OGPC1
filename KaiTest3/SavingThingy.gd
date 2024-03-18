class_name SaveGame
extends Node
const save_path = "user://savegame.tres"

@export var SavePos : Vector2 
@export var SpawnPos : Vector2 

func _ready():
	print(SpawnPos)

func SpawnPosUpdate(CheckpointPos : Vector2):
	SavePos = CheckpointPos
	save()
	loader()

func save() -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(SavePos)

func loader():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		SpawnPos = file.get_var(true)
		return SpawnPos
		print(SpawnPos)
