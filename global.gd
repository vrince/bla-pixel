extends Node

var selected_player : String = ""

signal player_selected(old_id, new_id)
signal button_pressed(id)

func select_player(id: String):
	if(id != selected_player):
		var old_id = selected_player
		selected_player = id
		emit_signal("player_selected", old_id, selected_player)

func press_button(id: String):
	print("button pressed", id)
	emit_signal("button_pressed", id)
