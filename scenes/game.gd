extends Node

@onready var viewport1 = $Viewports/P1/SubViewport
@onready var viewport2 = $Viewports/P2/SubViewport
@onready var camera1 = $Viewports/P1/SubViewport/Camera/Camera2D
@onready var camera2 = $Viewports/P2/SubViewport/Camera/Camera2D
@onready var level_builder = $LevelBuilder


func _ready():
	var map: Node2D = level_builder.build()
	viewport1.add_child(map)
	viewport2.world_2d = viewport1.world_2d
	camera1.target = map.get_node("Player_1")
	camera2.target = map.get_node("Player_2")
	
