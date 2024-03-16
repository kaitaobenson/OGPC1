extends CharacterBody2D

const PUSH_FORCE = 100

const WALK_SPEED = 350
const SPRINT_SPEED = 600
const JUMP_VELOCITY = 800

const NORMAL_GRAVITY = 2000
const SLIDING_GRAVITY = 9000
# Uh it kinda should be constant but I want change for slide ;/
var GRAVITY = NORMAL_GRAVITY

var slide_speed_change
var SLIDE_SPEED
var player_sliding = false
var can_slide = true
var slide_button_down = false
var player_direction = 0
var health:int = 100 
var player_speed = WALK_SPEED
var _attack_cooldown_over = true


var _jump_timer = 0.0
var _can_jump = false
var _coyote_time = 0.2

#I believe that beginning variables with underscore makes them private
@onready var _anim_manager = $AnimationManager
@onready var _particle_manager = $"../ParticleManager"
@onready var _attack_collision = $"AttackHitbox/AttackCollison"

var ALL_ANIMATIONS = preload("res://PlayerAnimations.gd").ALL_ANIMATIONS

func _ready():
	Global.Player = self
	
func _physics_process(delta):
	print(SLIDE_SPEED)
	push_other_bodies()
	particles_control()
	var inventory_is_on
	#is_inventory_on updater
	if(Input.is_action_just_pressed("inventory_toggle")):
		inventory_is_on = !inventory_is_on
	apply_gravity(delta)
	if player_sliding:
		player_speed = SLIDE_SPEED
	else:
		player_speed = WALK_SPEED
	
	if Input.is_action_just_pressed("slide") && !player_sliding && is_on_floor_custom() && can_slide:
		slide_button_down = true
		slide()
	elif Input.is_action_just_released("slide") && player_sliding:
		slide_button_down = false
		
	
	### ADD MOVEMENT ###
	if !player_sliding:
		player_direction = Input.get_axis("move_left", "move_right")
	wasd_movement(player_direction)
	
	### JUMP ###
	if is_on_floor_custom():
		_can_jump = true
		_jump_timer = 0.0
	else:
		_jump_timer += delta
		if _jump_timer < _coyote_time:
			_can_jump = true
		else:
			_can_jump = false
			
	if Input.is_action_just_pressed("jump") && _can_jump:
		jump()
		while is_on_floor_custom():
			await get_tree().create_timer(0.1).timeout
		_jump_timer = 100.0
	
	
func wasd_movement(direction : int):
	if direction != 0:
		_anim_manager.change_animation(ALL_ANIMATIONS.RUN, true)
	else:
		_anim_manager.change_animation(ALL_ANIMATIONS.RUN, false)
		velocity.x = 0
	
	if direction > 0:
		flip(true)
	elif direction < 0:
		flip(false)
	velocity.x = direction * player_speed
	
	
	move_and_slide()

func jump():
	velocity.y = -JUMP_VELOCITY
	_anim_manager.change_animation(ALL_ANIMATIONS.JUMP, true)
	
	
func apply_gravity(delta):
	if !is_on_floor_custom():
		GRAVITY = NORMAL_GRAVITY
	velocity.y += GRAVITY * delta
	
	
func slide():
	var floor_angle = get_floor_angle()
	var slow_or_speed : float
	player_sliding = true
	if player_direction == 0:
		SLIDE_SPEED = 200
		if get_floor_normal().x < 0:
			player_direction = -1
		elif get_floor_normal().x > 0:
			player_direction = 1
	else:
		SLIDE_SPEED = player_speed + floor_angle * 100 + 50
		while await get_tree().create_timer(0.5).timeout or !player_sliding:
			break
	while slide_button_down == true && SLIDE_SPEED > 0:
		floor_angle = get_floor_angle()
		await get_tree().create_timer(0.01).timeout
		_anim_manager.change_animation(ALL_ANIMATIONS.SLIDE, true)
		GRAVITY = SLIDING_GRAVITY
		
		await get_tree().create_timer(0.001).timeout
		if get_floor_normal().x < 0:
			if player_direction == 1:
				slow_or_speed = -3
			elif player_direction == -1:
				slow_or_speed = 5
		elif get_floor_normal().x > 0:
			if player_direction == 1:
				slow_or_speed = 5
			elif player_direction == -1:
				slow_or_speed = -3
		else:
			slow_or_speed = 0
		slide_speed_change = floor_angle * (abs(floor_angle) + 1) * slow_or_speed
		if slide_speed_change > 0:
			slide_speed_change += 1
		else:
			slide_speed_change -= 1
		if floor_angle == 0:
			slide_speed_change = -3
			
		SLIDE_SPEED += slide_speed_change
	
	#End skid
	while SLIDE_SPEED > 0:
		SLIDE_SPEED += -5
		await get_tree().create_timer(0.001).timeout
	
	player_sliding = false
	GRAVITY = NORMAL_GRAVITY
	_anim_manager.change_animation(ALL_ANIMATIONS.SLIDE, false)
	print("end slide")
	can_slide = false
	await get_tree().create_timer(1).timeout
	can_slide = true


func push_other_bodies():
	for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			
			if collision && collision.get_collider() is RigidBody2D:
				collision.get_collider().apply_central_impulse(-collision.get_normal() * PUSH_FORCE)
				
				
func die():
	get_tree().reload_current_scene()
	print("ouch")
	#whatever you wanna do when you die
	
	
func particles_control():
	if is_on_floor() && player_direction != 0:
		_particle_manager.set_particles_on(true)
	else:
		_particle_manager.set_particles_on(false)
		
		
func flip(isRight : bool):
	var nodes_to_flip = [
		$PlayerHitbox,
		$AttackManager,
		$AnimationManager,
		$HurtboxComponent
	]
	if isRight:
		for i in nodes_to_flip.size():
			nodes_to_flip[i].scale.x = 1
	if !isRight:
		for i in nodes_to_flip.size():
			nodes_to_flip[i].scale.x = -1
			
			
func is_on_floor_custom() -> bool:
	var left = $GroundRaycasts/Left
	var center = $GroundRaycasts/Center
	var right = $GroundRaycasts/Right
	
	if left.is_colliding() || center.is_colliding() || right.is_colliding():
		return true
	else: 
		return false
