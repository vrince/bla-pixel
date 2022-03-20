extends Node

var selected_player : String = ""
var level : int = 0

var levels := [
	"levels/level-0.tscn",
	"levels/level-1.tscn",
	"levels/level-2.tscn",
	"levels/level-3.tscn",
	"levels/mountain/level-0.tscn",
	"levels/mountain/level-1.tscn",
	"levels/desert/level-0.tscn"
]

signal player_selected(old_id, player_id)
signal button_pressed(button_id, player_id)
signal button_released(button_id, player_id)
signal item_picked(item, player_id)
signal item_consumed(item, player_id)
signal player_exited(player_id)
signal level_finished()
signal start_new_level(level_name)

func _ready():
	select_player("bastien")
	connect("level_finished", self, "_on_level_finished")

func select_player(player_id: String):
	var old_id = selected_player
	selected_player = player_id
	emit_signal("player_selected", old_id, selected_player)

func change_scene(scene: String):
	get_tree().change_scene(scene)
	emit_signal("start_new_level", scene)
	select_player("bastien")

func _input(event):
	if event.is_action_pressed("ui_end"):
		get_tree().change_scene("res://menu.tscn")

func _on_level_finished():
	level += 1
	print(level)
	if level < len(levels):
		var next_level = levels[level]
		change_scene(next_level)
	else:
		change_scene("res://menu.tscn")

