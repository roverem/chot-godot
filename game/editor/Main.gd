tool
extends Node2D


func _ready():
	$TileMap.connect("openPortalEditor", self, "_on_portal_edit")

func _on_portal_edit(sceneRes):
	$PortalEditor._loadScene(sceneRes)