extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sprite: Sprite2D = self.get_node("Sprite2D")
	sprite.rotate(deg_to_rad(randi_range(1, 4) * 90))
