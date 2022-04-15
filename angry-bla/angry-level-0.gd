extends Node2D


func _ready():
	$Elastic.player = $Creature
	$Creature.connect("released", $Elastic, "_on_player_released")
