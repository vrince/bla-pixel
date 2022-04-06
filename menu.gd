extends Control


func _ready():
	var list = $ItemList
	list.clear()
	list.set_focus_mode(0)
	for level in Global.levels:
		if not "end" in level:
			var text = level.replace("levels/", "").replace("/", " ").replace(".tscn", "").replace("-", " ")
			list.add_item(text)
	Global.connect("button_pressed", self, "_on_button")

func _on_button(button_id, player_id):
	if button_id == "level":
		var index = randi() % len(Global.levels)
		$ItemList.select(index)
		$ItemList.ensure_current_is_visible()
	elif button_id == "go":
		_on_Button_pressed()

func _on_Button_pressed():
	var selected_items = $ItemList.get_selected_items()
	if len(selected_items) > 0:
		Global.level = selected_items[0]
		var level_scene = Global.levels[Global.level]
		Global.change_scene(level_scene)

