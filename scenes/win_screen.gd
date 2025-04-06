extends Control

@onready var quit_button = $Menu/Quit
@onready var win_sfx = $Win

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	quit_button.connect("button_down", on_click_quit)

func _process(_delta: float) -> void:
	if visible && !get_tree().paused:
		get_tree().paused = true
		win_sfx.play()

func on_click_quit() -> void:
	get_tree().quit()
