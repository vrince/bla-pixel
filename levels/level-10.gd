extends Node2D

var diamonds : Node2D = null

func _ready():
	diamonds = $Diamonds
	remove_child($Diamonds)
	$Licorne.connect("catched", self, "_on_licorne_catched")

func _on_licorne_catched():
	add_child(diamonds)
	diamonds.visible = true
	
