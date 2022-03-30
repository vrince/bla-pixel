extends Node2D

export var energy: float = 0.75

func _ready():
	$Light2D.energy = energy


func _on_Area2D_body_entered(body):
	var player = body as Player
	if player:
		Global.increment_diamond()
		queue_free()
