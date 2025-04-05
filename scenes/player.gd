extends CharacterBody2D

enum PlayerId {P1 = 1, P2 = 2}

const SPEED = 150.0

@export var player_id: PlayerId

@onready var player_walking = $PlayerWalking

var ping

func _ready() -> void:
	ping = preload("res://scenes/ping.tscn")
func _physics_process(delta: float) -> void:
	
	# Handle Input
	velocity = Vector2.ZERO
	var player_prefix: String = "p" + str(player_id)
	if Input.is_action_pressed(player_prefix + "-down"):
		velocity.y += SPEED
	if Input.is_action_pressed(player_prefix + "-up"):
		velocity.y -= SPEED
	if Input.is_action_pressed(player_prefix + "-left"):
		velocity.x -= SPEED
	if Input.is_action_pressed(player_prefix + "-right"):
		velocity.x += SPEED
	if Input.is_action_just_pressed(player_prefix + "-sound"):
		var ping_instance = ping.instantiate()
		ping_instance.position = position
		add_sibling(ping_instance)
	
	if velocity == Vector2.ZERO: 
		player_walking.stop()
	elif !player_walking.playing:
		player_walking.play()
		
	# Handle Collusion
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
			print(collision_info)
			velocity = velocity.bounce(collision_info.get_normal())
