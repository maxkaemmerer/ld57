extends Control

@onready var quit_button = $Menu/HBoxContainer/VBoxContainer/Quit
@onready var start_button = $Menu/HBoxContainer/VBoxContainer/Start

signal start

func _ready() -> void:
	visible = true
	quit_button.connect("button_down", on_click_quit)
	start_button.connect("button_down", on_click_start)

func _process(_delta: float) -> void:
	if visible && !get_tree().paused:
		get_tree().paused = true

func on_click_quit() -> void:
	get_tree().quit()

func on_click_start():
	get_tree().paused = false
	visible =false
	start.emit()
