extends Node

var selected_player : String = ""

signal player_selected(old_id, player_id)
signal button_pressed(button_id)
signal object_picked(object_id, player_id)

func select_player(player_id: String):
	if(player_id != selected_player):
		var old_id = selected_player
		selected_player = player_id
		emit_signal("player_selected", old_id, selected_player)

func press_button(button_id: String):
	print("button pressed " + button_id)
	emit_signal("button_pressed", button_id)

func pick_object(object: Node2D, player_id: String):
	print("object picked " + object.name + " by " + player_id)
	emit_signal("object_picked", object, player_id)
