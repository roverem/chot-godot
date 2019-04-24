extends Node

class_name GameState

var data = {}

const ACQUIRING_MISSION = 0
const DELIVERING_MESSAGE = 1
const RETRIEVING_PAY = 2

func _init():
	data["state"] = ACQUIRING_MISSION

func _ready():
	pass
	