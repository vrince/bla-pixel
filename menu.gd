extends Control


func _ready():
	var list = $ItemList
	list.clear()
	for level in Global.levels:
		var text = level.replace("levels/", "").replace("/", " ").replace(".tscn", "").replace("-", " ")
		list.add_item(text)


func _on_Button_pressed():
	var selected_items = $ItemList.get_selected_items()
	if len(selected_items) > 0:
		var level = Global.levels[selected_items[0]]
		get_tree().change_scene(level)
		emit_signal("start_new_level", level)
