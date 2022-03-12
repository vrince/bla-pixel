extends Node2D

export var id := "_"
export var type := "flag"

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.animation = type


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
