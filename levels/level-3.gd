extends Node2D


func _ready():
	Global.connect("button_pressed", self, "_on_button_pressed")

func _on_button_pressed(button_id, player_id):
	$TileMapBlock.queue_free()
