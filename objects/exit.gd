extends Node2D

export var expected_player := 3
var players : Array = []

func _ready():
	pass

func _on_Area2D_body_entered(body):
	var player = body as Player
	if player and not players.has(player.id):
		players.push_back(player.id)
		print("player ", player.id, " exit")
		Global.emit_signal("player_exited", player.id)
		if len(players) >= expected_player:
			print("level finished")
			Global.emit_signal("level_finished")
	
