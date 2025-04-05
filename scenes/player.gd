extends CharacterBody2D


const SPEED = 150.0
@export var player_prefix = "p1"


func _physics_process(delta: float) -> void:	
	velocity = Vector2(0, 0)
	
	if Input.is_action_pressed(player_prefix + "-down"):
		velocity.y += SPEED
	if Input.is_action_pressed(player_prefix + "-up"):
		velocity.y -= SPEED
	if Input.is_action_pressed(player_prefix + "-left"):
		velocity.x -= SPEED
	if Input.is_action_pressed(player_prefix + "-right"):
		velocity.x += SPEED
	if Input.is_action_just_pressed(player_prefix + "-sound"):
		print("Sound " + player_prefix)
		
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
			print(collision_info)
			velocity = velocity.bounce(collision_info.get_normal())
