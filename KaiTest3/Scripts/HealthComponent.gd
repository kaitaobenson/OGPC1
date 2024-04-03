extends Node2D

class_name HealthComponent

@export var max_health : int = 100
@export_multiline var health_bar : String
var health : int

func _ready():
	get_node("/root/Node2D/SavingThingy").loader()
	if get_node("/root/Node2D/SavingThingy").find_saved_value("Health") <= 0:
		health = max_health
	else:
		health = get_node("/root/Node2D/SavingThingy").find_saved_value("Health")
	update_health_bar()

func damage(attack:Attack):
	health -= attack.attack_damage
	update_health_bar()
	if health <= 0:
		$"../".die()
		
func update_health_bar():
	if get_node(health_bar) != null:
		get_node(health_bar).set_health(health)
