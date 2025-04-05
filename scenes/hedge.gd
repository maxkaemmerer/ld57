extends StaticBody2D

func _ready() -> void:
	var sprite: Sprite2D = self.get_node("./Sprite2D")
	sprite.rotate(deg_to_rad(randi_range(1, 4) * 90))
