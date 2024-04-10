extends Area2D

#first is damage, second is if it stops for i frames
#spikes and bottom barrier don't care about i frames
const enemy_info = {
	"Spikes": [100, false],
	"BottomBarrierDeath" : [100, false],
	"BugEnemy": [20, true],
	"Zombie Husk Guy": [0, true],
}

const i_frame_time: float = 0.5
const health_regen_time: float = 10

var bodies_in_hurtbox = []
var areas_in_hurtbox = []

@onready var health_component = $"../HealthComponent"

var _i_frames_done = true
var timer : float = 0

func _process(delta):
	check_for_enemies()
	regen_health(delta)


func _on_body_entered(body):
	if bodies_in_hurtbox.has(body.name) == false:
		bodies_in_hurtbox.append(body.name)


func _on_body_exited(body):
	if bodies_in_hurtbox.has(body.name):
		bodies_in_hurtbox.erase(body.name)


func _on_area_entered(area):
	if areas_in_hurtbox.has(area.name) == false:
		areas_in_hurtbox.append(area.name)


func _on_area_exited(area):
	if areas_in_hurtbox.has(area.name):
		areas_in_hurtbox.erase(area.name)


func regen_health(delta):
	timer += delta
	if timer >= health_regen_time:
		timer = 0
		if health_component.health <= 95:
			make_attack(-5)
		elif health_component.health < 100:
			make_attack(100 - health_component.health)


func check_for_enemies():
	for i in range(bodies_in_hurtbox.size()):
		if enemy_info.has(bodies_in_hurtbox[i]):
			var current_info = enemy_info.get(bodies_in_hurtbox[i])
			
			if current_info[1] == true:
				if _i_frames_done:
					make_attack(current_info[0])
					i_frames_on(i_frame_time)
			if current_info[1] == false:
				make_attack(current_info[0])
				
	for i in range(areas_in_hurtbox.size()):
		if enemy_info.has(areas_in_hurtbox[i]):
			var current_info = enemy_info.get(areas_in_hurtbox[i])
			
			if current_info[1] == true:
				if _i_frames_done:
					make_attack(current_info[0])
					i_frames_on(i_frame_time)
			if current_info[1] == false:
				make_attack(current_info[0])


func i_frames_on(seconds : float):
	_i_frames_done = false
	await get_tree().create_timer(seconds).timeout
	_i_frames_done = true


func make_attack(damage : int):
	var attack = Attack.new()
	attack.attack_damage = damage
	print(attack.attack_damage)
	health_component.damage(attack)



func is_in_shelter() -> bool:
	if areas_in_hurtbox.has("ShelterArea"):
		return true
	else:
		return false

func is_in_fire() -> bool:
	if areas_in_hurtbox.has("FireArea"):
		return true
	else:
		return false

func is_in_water() -> bool:
	if areas_in_hurtbox.has("WaterArea"):
		return true
	else:
		return false