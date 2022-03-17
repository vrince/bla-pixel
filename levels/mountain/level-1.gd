extends Node2D

func _ready():
	Global.connect("button_pressed", self, "_on_button_pressed")
	Global.connect("button_released", self, "_on_button_released")
	$Platform/DampedSpringJoint2D.stiffness = 15

func _on_button_pressed(button_id, player_id):
	$Platform/DampedSpringJoint2D.stiffness = 280

func _on_button_released(button_id, player_id):
	$Platform/DampedSpringJoint2D.stiffness = 15
