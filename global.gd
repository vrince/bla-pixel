extends Node

var select_player : int = KEY_0

signal player_selected(old_id, new_id)

func select_player(id: int):
	if(id != select_player):
		var old_id = select_player
		select_player = id
		emit_signal("player_selected", old_id, select_player)
