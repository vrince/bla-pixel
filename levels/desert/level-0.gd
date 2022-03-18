extends Node2D

func _ready():
	Global.connect("button_pressed", self, "_on_button_pressed")
	$ObjectSource.probability = 0.5
	$ObjectSource2.probability = 0.5
	$ObjectSource3.probability = 0.7

func _on_button_pressed(button_id, player_id):
	$ObjectSource.probability = 0.1
	$ObjectSource2.probability = 0.1
	$ObjectSource3.probability = 0.25
