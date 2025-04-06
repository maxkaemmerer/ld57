extends Control

@onready var quit_button = $Menu/Quit
@onready var resume_button = $Menu/Resume

func _ready() -> void:
	visible = false
	quit_button.connect("button_down", on_click_quit)
	resume_button.connect("button_down", on_click_resume)

func _process(_delta: float) -> void:
	if visible && !get_tree().paused:
		get_tree().paused = true

func on_click_quit() -> void:
	get_tree().quit()

func on_click_resume():
	get_tree().paused = false
	visible =false
