extends Node2D


func _ready():
	$DampedSpringJoint2D2.stiffness = 500

func _physics_process(delta):
	$DampedSpringJoint2D2.position.y = $"vertical-platform".position.y
