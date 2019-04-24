extends Node2D

class_name Motorcycle

# Declare an empty dictionary object
var game = {}

func _ready():
	# Initialize a player dictionary
	var player = {
		"name": "Thor",
		"inventory": ["sword", "shield", "map"],
		"location": "Castellion",
		"energy": 67
	}
	
	if game.empty():
		# Add data to the game dictionary
		game["player"] = player
		game["score"] = 0
		game["dummy"] = null
	
	if game.has("dummy"):
		game.erase("dummy")
	
	print(game.get("dummy", "Key not found!"))
	
	if game.has_all(["player", "score"]):
		print(game["player"]["name"])
	
	player["energy"] += 1
	
	print(game.keys().size())
	print(game.size())
	print(player.values()[0])
	
	# Alternative way to initialize a dictionary
	var d = {
		a = {
			a1 = {
				a11 = 1, a12 = 2
			},
			a2 = 3
		},
		b = 1
	}
	
	# Make copies of the dictionary
	var deep_copy = d.duplicate(true)
	var shallow_copy = d.duplicate()
	print(deep_copy)
	# I expected the shallow copy to be truncated
	print(shallow_copy)
