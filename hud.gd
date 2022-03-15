extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("player_selected", self, "_on_player_selected")

func _on_player_selected(old_id: String, new_id: String):
	$PanelContainer/PlayerLabel.text = new_id

