extends Node

@onready var viewport1 = $Viewports/P1/SubViewport
@onready var viewport2 = $Viewports/P2/SubViewport
@onready var camera1 = $Viewports/P1/SubViewport/Camera/Camera2D
@onready var camera2 = $Viewports/P2/SubViewport/Camera/Camera2D
@onready var world = $Viewports/P1/SubViewport/Level


func _ready():
	viewport2.world_2d = viewport1.world_2d
	camera1.target = world.get_node("Player_1")
	camera2.target = world.get_node("Player_2")
