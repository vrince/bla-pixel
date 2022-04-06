extends Node

var selected_player : String = ""
var level : int = 0
var start_scene_time : int = -1
var level_time : int = 300
var count_down : int = -1
var diamond_count: int = 0
var lives = {"bastien": 0, "lucille": 0, "adeline": 0}

var levels := [
	"levels/level-0.tscn",
	"levels/level-1.tscn",
	"levels/level-2.tscn",
	"levels/level-3.tscn",
	"levels/level-4.tscn",
	"levels/level-5.tscn",
	"levels/level-6.tscn",
	"levels/level-7.tscn",
	"levels/level-8.tscn",
	"levels/level-9.tscn",
	"levels/level-10.tscn",
	"end.tscn"
]

signal player_selected(old_id, player_id)
signal button_pressed(button_id, player_id)
signal button_released(button_id, player_id)
signal item_picked(item, player_id, texture)
signal item_consumed(item, player_id)
signal player_exited(player_id)
signal level_finished()
signal start_new_level(level_name)
signal count_down(level_name)
signal diamond_count_changed(count)
signal new_player(player_id)

func _ready():
	select_player("bastien")
	connect("level_finished", self, "_on_level_finished")

func select_player(player_id: String):
	var old_id = selected_player
	selected_player = player_id
	emit_signal("player_selected", old_id, selected_player)

func new_player(player_id: String):
	lives[player_id] += 1
	emit_signal("new_player", player_id)

func increment_diamond():
	diamond_count += 1
	emit_signal("diamond_count_changed", diamond_count)

func change_scene(scene: String):
	start_scene_time = OS.get_unix_time()
	count_down = -1
	get_tree().change_scene(scene)
	emit_signal("start_new_level", scene)
	select_player("bastien")

func _input(event):
	if event.is_action_pressed("ui_end"):
		get_tree().change_scene("res://menu.tscn")

func _on_level_finished():
	level += 1
	if level < len(levels):
		var next_level = levels[level]
		change_scene(next_level)
	else:
		change_scene("res://menu.tscn")

func _process(delta):
	if start_scene_time > 0:
		var time_elapsed = OS.get_unix_time() - start_scene_time
		var new_count_down = level_time - time_elapsed
		if new_count_down != count_down:
			count_down = new_count_down
			emit_signal("count_down", count_down)
