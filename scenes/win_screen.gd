extends Control

@onready var quit_button = $Menu/Quit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	quit_button.connect("button_down", quit)


func quit() -> void:
	print("quit")
	get_tree().quit()
