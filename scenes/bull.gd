extends CharacterBody2D


enum BullState {CHARGING, SEARCHING, FOLLOWING, WANDERING}


@onready var vision = $RayCast2D
@onready var sprite = $Sprite2D
@onready var charge_cooldown = $ChargeCooldown
@onready var search_timer = $SearchTimer

@export var charge_cooldown_time = 10
@export var search_time = 5

@export var wander_speed = 100.0
@export var charge_speed = 300.0
@export var follow_speed = 150.0
@export var rotation_speed = 3.0

var can_charge = true
var bull_state: BullState = BullState.SEARCHING

var last_known_target
var wander_direction: Vector2 = Vector2.DOWN

func _ready() -> void:
	velocity = Vector2.DOWN
	charge_cooldown.connect("timeout", on_charge_cooldown_expired)
	search_timer.connect("timeout", on_finished_searching)
	search_timer.start(search_time)

func speed():
	if bull_state == BullState.CHARGING:
		return charge_speed
	elif bull_state == BullState.FOLLOWING:
		return follow_speed
	else:
		return wander_speed

func _physics_process(delta: float) -> void:
	# Look if we see the player
	if bull_state != BullState.CHARGING && vision.is_colliding():
		var collider = vision.get_collider()
		if collider && "Player" in collider.name:
			bull_state = BullState.FOLLOWING
			last_known_target = collider.position
			if can_charge:
				bull_state = BullState.CHARGING
				velocity = position.direction_to(last_known_target) * speed()
				charge_cooldown.start(charge_cooldown_time)
	
	if bull_state == BullState.CHARGING:
		print("Charging")
	elif bull_state == BullState.SEARCHING:
		# Turn, looking for the player
		rotation += delta * rotation_speed
	elif bull_state == BullState.WANDERING:
		velocity = wander_direction * speed()
		# Not sure why i need the -90 degree here
		rotation = wander_direction.angle() + deg_to_rad(-90)
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
			velocity = Vector2.ZERO
	
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
			last_known_target = null
			var collider = collision_info.get_collider()
			print("Colided: " + collider.name)
			if bull_state == BullState.CHARGING:
				bull_state = BullState.SEARCHING
				search_timer.start(search_time)
				can_charge = false
				if "Hedge" in collider.name && collider.destructable:
					print("Collided with destructable Hedge: " + collider.name)
					collider.queue_free()
			else:
				wander_direction = pick_wander_direction()
			
			if "Player" in collider.name:
				print("Squashed: " + collider.name)
				collider.hurt()


func on_charge_cooldown_expired():
	can_charge = true

func on_finished_searching():
	bull_state = BullState.WANDERING
	
func pick_wander_direction():
	return [Vector2.DOWN, Vector2.LEFT, Vector2.UP, Vector2.RIGHT][randi_range(0, 3)]
