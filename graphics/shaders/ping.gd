extends Node2D

@onready var particles = $CPUParticles2D

func _ready() -> void:
	particles.emitting = true
	particles.finished.connect(on_finished)

func on_finished():
	queue_free()
