extends Node

@onready var viewport1 = $Viewports/P1/SubViewport
@onready var viewport2 = $Viewports/P2/SubViewport
@onready var camera1 = $Viewports/P1/SubViewport/Camera/Camera2D
@onready var camera2 = $Viewports/P2/SubViewport/Camera/Camera2D
@onready var level_builder = $LevelBuilder
var win_screen_resource

var p1_spawn_point: Vector2
var p2_spawn_point: Vector2
var map: Node2D

func _ready():
	win_screen_resource = preload("res://scenes/win_screen.tscn")
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

func on_p1_died():
	map.get_node("Player_1").position = p1_spawn_point
func on_p2_died():
	map.get_node("Player_2").position = p2_spawn_point

func on_players_meet():
	var win_screen_instance = win_screen_resource.instantiate()
	add_child(win_screen_instance)
	get_tree().paused = true
