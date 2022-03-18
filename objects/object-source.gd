extends Node2D

export var type := "box"
export var probability := 0.5
const BOX = preload("res://objects/box.tscn")
var generator = RandomNumberGenerator.new()

func _ready():
	generator.randomize()
	
func _process(delta):
	if generator.randf() > 0.9 + (0.1 - probability / 10.0):
		add_child(BOX.instance())
