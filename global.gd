extends Node

var selected_player : String = ""
var level : int = 0

var levels := [
	"levels/main.tscn",
	"levels/level-0.tscn",
	"levels/level-1.tscn"
]

signal player_selected(old_id, player_id)
signal button_pressed(button_id)
signal object_picked(object_id, player_id)
signal player_exited(player_id)
signal level_finished()
signal start_new_level(level_name)

func _ready():
	connect("level_finished", self, "_on_level_finished")

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

func _on_level_finished():
	level += 1
	print(level)
	if level < len(levels):
		var next_level = levels[level]
		get_tree().change_scene(next_level)
		emit_signal("start_new_level", next_level)
	else:
		print("game finished !")
