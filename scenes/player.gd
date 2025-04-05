extends CharacterBody2D


const SPEED = 150.0


func _physics_process(delta: float) -> void:	
	velocity = Vector2(0, 0)
	
	if Input.is_action_pressed("p1-down"):
		velocity.y += SPEED
	if Input.is_action_pressed("p1-up"):
		velocity.y -= SPEED
	if Input.is_action_pressed("p1-left"):
		velocity.x -= SPEED
	if Input.is_action_pressed("p1-right"):
		velocity.x += SPEED
	if Input.is_action_just_pressed("p1-sound"):
		print("Sound P1")
		
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
			print(collision_info)
			velocity = velocity.bounce(collision_info.get_normal())
