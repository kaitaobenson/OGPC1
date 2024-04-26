extends CharacterBody2D


const bulletPath = preload("res://Scenes/turret_bullet.tscn")
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var SPEED
var can_see : bool = false
var can_fire = true
var direction = 1

@onready var Player = Global.Player
@onready var line_of_sight = $"LineOfSightPivot/LineOfSight" as RayCast2D
@onready var line_of_sight_pivot = $"LineOfSightPivot" as Node2D

func _ready():
	pass

func _physics_process(delta):	
	move_and_slide()
	raycast_direction()
	is_in_range()
	
	if can_see && can_fire:
		fire_bullet()
	
	if !can_see:
		idle()
	else:
		fighting()
	
	if not is_on_floor():
		velocity.y += gravity * delta
	velocity.x = direction * SPEED
	
	

func is_in_range():
	var who_i_see = line_of_sight.get_collider()
	var can_i_see = line_of_sight.is_colliding()
	if who_i_see == Player:
		can_see = true
	else:
		await get_tree().create_timer(0.25).timeout
		if who_i_see == Player:
			can_see = true
		else:
			can_see = false

func raycast_direction():
	var direction_to_player : Vector2 = Vector2(Player.global_position.x, Player.global_position.y - 8) - line_of_sight.position
	line_of_sight_pivot.look_at(direction_to_player)

func fire_bullet():
	can_fire = false
	var bullet = bulletPath.instantiate()
	var bullet_pos : Vector2
	# Prevents bullets from blocking line of sight
	line_of_sight.add_exception(bullet)
	# Offsets spawn position depending on if you are to the right or to the left
	# so it doesnt spawn inside the turret
	if Player.global_position.x - global_position.x > 0:
		bullet_pos = Vector2(global_position.x + 60, global_position.y - 30)
	else:
		bullet_pos = Vector2(global_position.x - 60, global_position.y - 30)
	
	var bullet_container = Node2D.new()
	add_child(bullet_container)
	var bullet_container_node = get_node(str(bullet_container.name))
	
	
	bullet_container_node.add_child(bullet)
	bullet.global_position = bullet_pos
	bullet.velociter = Player.global_position - bullet.global_position
	await get_tree().create_timer(1).timeout
	
	can_fire = true
	

func idle():
	SPEED = 50.0
	var random_flip = randi_range(1, 100)
	var can_random_flip = true
	var flip : bool = false
	var leftwallcheck = $"Raycasts/leftwallcheck".is_colliding()
	var rightwallcheck = $"Raycasts/rightwallcheck".is_colliding()
	var leftfloorcheck = $"Raycasts/leftfloorcheck".is_colliding()
	var rightfloorcheck = $"Raycasts/rightfloorcheck".is_colliding()
	var leftsidecheck = $"Raycasts/leftsidecheck".is_colliding()
	var rightsidecheck = $"Raycasts/rightsidecheck".is_colliding()
	if direction == -1 and (leftwallcheck or !leftfloorcheck or leftsidecheck) or direction == 1 and (rightwallcheck or !rightfloorcheck or rightsidecheck):
		flip = true
	if (random_flip == 1 && can_random_flip) or flip:
		can_random_flip = false
		direction = -direction
		await get_tree().create_timer(2.0).timeout
		can_random_flip = true

func fighting():
	SPEED = 100
	var distance_to_playerX = Player.global_position.x - global_position.x
	var player_left_or_right = distance_to_playerX / abs(distance_to_playerX)
	if abs(distance_to_playerX) < 300:
		direction = -player_left_or_right
		print("too close!")
	elif abs(distance_to_playerX) > 400:
		direction = player_left_or_right
		print("too far!")
	else:
		direction = 0
		print("just right!")

func die():
	queue_free()
