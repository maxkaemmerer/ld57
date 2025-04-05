extends CharacterBody2D


const SPEED = 150.0

@onready var vision = $RayCast2D

var target

func _ready() -> void:
	velocity = Vector2.DOWN

func _physics_process(delta: float) -> void:
	print(target, velocity)
	vision.target_position = Vector2.DOWN * 50
	
	if vision.is_colliding():
		var collider = vision.get_collider()
		print(collider.name)
		if "Player" in collider.name:
			target = collider.position
	elif target:
		target = null
	
	if target:
		velocity = position.direction_to(target) * SPEED

	
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
			pass
			#print(collision_info)
			#velocity = velocity.bounce(collision_info.get_normal())
