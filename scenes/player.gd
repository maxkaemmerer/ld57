extends CharacterBody2D


const SPEED = 150.0

@export var player_id: int
@export var default_life_points = 3
@export var hurt_cooldown = 1

@onready var player_walking = $PlayerWalking
@onready var sprite = $AnimatedSprite2D
@onready var hurt_cooldown_timer = $HurtCooldown
@onready var hurt_sfx = $Hurt
@onready var die_sfx = $Die

var ping
var life_points
var hurtable = true

signal died
signal meet

func _ready() -> void:
	ping = preload("res://scenes/ping.tscn")
	life_points = default_life_points
	if player_id == 2:
		sprite.modulate = Color(.9, .6, .4)
	hurt_cooldown_timer.connect("timeout", on_hurt_cooldown_finished)

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
		sprite.animation = "stand"
	elif !player_walking.playing:
		player_walking.play()
		sprite.animation = "walk"
		sprite.play()
		
	# Handle Collusion
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		if "Player" in collision_info.get_collider().name:
			meet.emit()
		velocity = velocity.bounce(collision_info.get_normal())
				
	if life_points == 0:
		die_sfx.play()
		died.emit()
		life_points = default_life_points

func on_hurt_cooldown_finished():
	hurtable = true

func hurt():
	print("Hurt", hurtable)
	if hurtable:
		hurt_sfx.play()
		life_points -= 1
		hurt_cooldown_timer.start(hurt_cooldown)
		hurtable = false
