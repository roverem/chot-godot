extends Node2D

func _ready():
	$arrow_south.visible= false
	$arrow_north.visible= false
	$arrow_east.visible= false
	$arrow_west.visible= false

func set_directions(north, south, east, west):
	$arrow_south.visible= south
	$arrow_north.visible= north
	$arrow_east.visible= east
	$arrow_west.visible= west
	