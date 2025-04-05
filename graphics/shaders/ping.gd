extends Node2D


func _ready() -> void:
	var particles: CPUParticles2D = get_node("CPUParticles2D")
	particles.emitting = true
	particles.finished.connect(on_finished)

func on_finished():
	queue_free()
