extends Node2D

func _ready():
	Global.connect("button_pressed", self, "_on_button_pressed")
	Global.connect("item_consumed", self, "_on_item_consumed")
	
	$Key.visible = false
	$Exit.visible = false

func _on_button_pressed(button_id, player_id):
	$Key.visible = true
	
func _on_item_consumed(item, player_id):
	$Exit.visible = true
