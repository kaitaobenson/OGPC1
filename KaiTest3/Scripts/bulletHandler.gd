extends CharacterBody2D
# Called when the node enters the scene tree for the first time.
func fire(angle,fdamage,speed)->void:
	self.visible = true
	self.get_node("hitbox").set_deferred("disabled", false)
	set_meta("damage",fdamage)
	self.rotation = angle
	velocity.y = sin(angle)
	velocity.x = cos(angle)
	velocity = velocity * speed
func _ready():
	velocity.x = 0
	velocity.y = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var collision = move_and_collide(velocity*delta)
	if collision:
		var damage = get_meta("damage")
		if (collision.get_collider().has_method("_hitByBullet")):
			collision.get_collider()._hitByBullet(damage)
		self.queue_free()
