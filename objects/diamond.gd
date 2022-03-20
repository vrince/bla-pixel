extends Node2D


func _ready():
	pass


func _on_Area2D_body_entered(body):
	var player = body as Player
	if player:
		queue_free()
