extends Node2D

func _ready():
	Global.connect("button_pressed", self, "_on_button_pressed")
	$Platform/DampedSpringJoint2D.stiffness = 15
	$Platform2/DampedSpringJoint2D.stiffness = 15

func _on_button_pressed(button_id, player_id):
	$Platform/DampedSpringJoint2D.stiffness = 500
	$Platform2/DampedSpringJoint2D.stiffness = 500

