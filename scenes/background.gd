extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.size = get_viewport().get_visible_rect().size
