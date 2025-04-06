extends Node


var hedge = preload("res://scenes/hedge.tscn")
var floor_ = preload("res://scenes/floor.tscn")
var player = preload("res://scenes/player.tscn")
var bull = preload("res://scenes/bull.tscn")

@export var level_images: Array[CompressedTexture2D]
@export var tile_size = 16
@export var random_level_selection = false

# Called when the node enters the scene tree for the first time.
func build() -> Node2D:
	var level_image = level_images.pick_random() if random_level_selection else level_images.front()
	
	var map: Node2D = Node2D.new()
	var level_width = level_image.get_image().get_width()
	var level_height = level_image.get_image().get_height()
	
	for y in range(0, level_image.get_image().get_height()):
		for x in range (0, level_width):
			var pixel = level_image.get_image().get_pixel(x,y)
			var tile_position = Vector2(x * tile_size, y * tile_size)
			
			if pixel == Color(1, 0, 0, 1):
				var player_tile = player.instantiate()
				player_tile.player_id = 1
				player_tile.name = "Player_1"
				player_tile.position = tile_position
				map.add_child(player_tile)
				
			
			if pixel == Color(1, 1, 0, 1):
				var bull_tile = bull.instantiate()
				bull_tile.name = "Bull"
				bull_tile.position = tile_position
				map.add_child(bull_tile)
			
			elif pixel == Color(0, 0, 1, 1):
				var player_tile = player.instantiate()
				player_tile.player_id = 2
				player_tile.name = "Player_2"
				player_tile.position = tile_position
				map.add_child(player_tile)
			
			elif pixel == Color(0, 1, 0, 1):
				var hedge_tile = hedge.instantiate()
				hedge_tile.name = "Hedge_" + str(x) + str(y)
				hedge_tile.destructable = !(x == 0 || x == level_width -1 || y == 0 || y == level_height - 1)
				hedge_tile.position = tile_position
				map.add_child(hedge_tile)

			var floor__tile = floor_.instantiate()
			floor__tile.position = tile_position
			floor__tile.name = "Floor_" + str(x) + str(y)
			map.add_child(floor__tile)

	return map
