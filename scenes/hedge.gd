extends StaticBody2D

@onready var sprite = $Sprite2D

var destructable = true

func _ready() -> void:
	sprite.rotate(deg_to_rad(randi_range(1, 4) * 90))
