extends Node

@onready var viewport1 = $Viewports/P1/SubViewport
@onready var viewport2 = $Viewports/P2/SubViewport
@onready var camera1 = $Viewports/P1/SubViewport/Camera/Camera2D
@onready var camera2 = $Viewports/P2/SubViewport/Camera/Camera2D
@onready var level_builder = $LevelBuilder
@onready var music_manager = $MusicManager/CalmMusic
@onready var pause_menu = $PauseMenu
@onready var win_screen = $WinScreen
@onready var main_menu = $MainMenu
@onready var try_again_message = $"TryAgain!"
@onready var try_again_hide_timer = $HideTryAgain

var win_screen_resource
var p1_spawn_point: Vector2
var p2_spawn_point: Vector2
var map: Node2D

func _ready():
	main_menu.connect("start", start_game)
	try_again_hide_timer.connect("timeout", hide_try_again)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		pause_menu.visible = true

func on_p1_died():
	try_again()
	map.get_node("Player_1").position = p1_spawn_point

func on_p2_died():
	try_again()
	map.get_node("Player_2").position = p2_spawn_point

func on_players_meet():
	win_screen.visible = true
	
func start_game():
	map = level_builder.build()
	viewport1.add_child(map)
	viewport2.world_2d = viewport1.world_2d
	
	var p1 = map.get_node("Player_1")
	var p2 = map.get_node("Player_2")
	camera1.target = p1
	camera2.target = p2
	p1_spawn_point = p1.position
	p2_spawn_point = p2.position
	p1.connect("died", on_p1_died)
	p2.connect("died", on_p2_died)
	p1.connect("meet", on_players_meet)
	p2.connect("meet", on_players_meet)
	
	music_manager.play()


func try_again():
	try_again_message.visible = true
	try_again_hide_timer.start(3)

func hide_try_again():
	try_again_message.visible = false
