extends CharacterBody2D


enum BullState {CHARGING, SEARCHING, FOLLOWING, WANDERING}


@onready var vision = $RayCast2D
@onready var charge_cooldown = $ChargeCooldown
@onready var search_timer = $SearchTimer
@onready var foot_steps = $Steps
@onready var bull_charged_wall_sfx = $BullChargedWall
@onready var bull_charges_sfx = $BullCharges
@onready var animation = $AnimatedSprite2D

@onready var wall_detect_left = $Left
@onready var wall_detect_right = $Right
@onready var wall_detect_top = $Top
@onready var wall_detect_bottom = $Bottom

@export var charge_cooldown_time = 10
@export var search_time = 5

@export var wander_speed = 100.0
@export var charge_speed = 300.0
@export var follow_speed = 150.0
@export var rotation_speed = 3.0

signal following
signal charging
signal searching
signal wandering

var can_charge = true
var bull_state: BullState = BullState.SEARCHING

var last_known_target
var wander_direction: Vector2 = Vector2.DOWN
var previous_wander_direction: Vector2
var previous_valid_drections: Array[Vector2]

func _ready() -> void:
	velocity = Vector2.DOWN
	charge_cooldown.connect("timeout", on_charge_cooldown_expired)
	search_timer.connect("timeout", on_finished_searching)
	search_timer.start(search_time)
	animation.play("search")

func speed():
	if bull_state == BullState.CHARGING:
		return charge_speed
	elif bull_state == BullState.FOLLOWING:
		return follow_speed
	else:
		return wander_speed

func _physics_process(delta: float) -> void:
	if bull_state == BullState.CHARGING || bull_state == BullState.FOLLOWING || bull_state == BullState.WANDERING:
		if !foot_steps.playing:
			foot_steps.play()
		
		if bull_state == BullState.CHARGING:
			foot_steps.pitch_scale = 1.6
		elif bull_state == BullState.WANDERING: 
			foot_steps.pitch_scale = 1.2
		else:
			foot_steps.pitch_scale = 1.4
	else:
		foot_steps.stop()
	
	# Look if we see the player
	if bull_state != BullState.CHARGING && vision.is_colliding():
		var collider = vision.get_collider()
		if collider && "Player" in collider.name:
			bull_state = BullState.FOLLOWING
			animation.play("walk")
			following.emit()
			last_known_target = collider.global_position
			if can_charge:
				bull_state = BullState.CHARGING
				animation.play("walk")
				charging.emit()
				velocity = position.direction_to(last_known_target) * speed()
				charge_cooldown.start(charge_cooldown_time)
				bull_charges_sfx.play()
	
	if bull_state == BullState.CHARGING:
		print("Charging")
	elif bull_state == BullState.SEARCHING:
		# Turn, looking for the player
		vision.rotation += delta * rotation_speed
	elif bull_state == BullState.WANDERING:
		previous_wander_direction = wander_direction
		wander_direction = pick_wander_direction()
		
		velocity = wander_direction * speed()
		# Not sure why i need the -90 degree here
		vision.rotation = wander_direction.angle() + deg_to_rad(-90)
	elif bull_state == BullState.FOLLOWING:
		# Arrived where it last saw the player and stops
		if last_known_target && position.distance_to(last_known_target) < 5:
			last_known_target = null
			velocity = Vector2.ZERO
		
		# Move towards where we last saw the player
		if last_known_target:
			velocity = position.direction_to(last_known_target) * speed()
		else:
			bull_state = BullState.SEARCHING
			animation.play("search")
			searching.emit()
			velocity = Vector2.ZERO
	
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
			last_known_target = null
			var collider = collision_info.get_collider()
			print("Colided: " + collider.name)
			if bull_state == BullState.CHARGING:
				bull_state = BullState.SEARCHING
				animation.play("stand")
				searching.emit()
				search_timer.start(search_time)
				can_charge = false
				if "Hedge" in collider.name:
					bull_charged_wall_sfx.play()
					if collider.destructable:
						print("Collided with destructable Hedge: " + collider.name)
						collider.queue_free()
			else:
				wander_direction = pick_wander_direction(true)
			
			if "Player" in collider.name:
				print("Squashed: " + collider.name)
				collider.hurt()


func on_charge_cooldown_expired():
	can_charge = true

func on_finished_searching():
	bull_state = BullState.WANDERING
	animation.play("walk")
	wandering.emit()
	
func pick_wander_direction(force_new: bool = false):
	var valid_directions: Array[Vector2] = []
	if !wall_detect_left.is_colliding():
		valid_directions.append(Vector2.LEFT)
	if !wall_detect_right.is_colliding():
		valid_directions.append(Vector2.RIGHT)
	if !wall_detect_bottom.is_colliding():
		valid_directions.append(Vector2.DOWN)
	if !wall_detect_top.is_colliding():
		valid_directions.append(Vector2.UP)
	if force_new || previous_valid_drections != valid_directions:
		previous_valid_drections = valid_directions
		if len(valid_directions) > 1:
			# Try to avoid going back and forth all the time
			return valid_directions.filter(func(valid_direction): return valid_direction != Vector2(1 / previous_wander_direction.x, 1 / previous_wander_direction.y)).pick_random()
		return valid_directions.pick_random()
	else:
		return previous_wander_direction
