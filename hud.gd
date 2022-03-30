extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	_on_player_selected("", Global.selected_player)
	_on_diamond_count_changed(Global.diamond_count)
	Global.connect("player_selected", self, "_on_player_selected")
	Global.connect("player_oupsed", self, "_on_player_oupsed")
	Global.connect("diamond_count_changed", self, "_on_diamond_count_changed")

func _on_player_selected(old_id: String, new_id: String):
	$PlayerLabel.text = new_id

func _on_diamond_count_changed(count):
	$DiamondLabel.text = str(Global.diamond_count).pad_zeros(3)
	
func _on_player_oupsed(count):
	$BastienLabel.text = "B " + str(Global.lives["bastien"])
	$LucilleLabel.text = "L " + str(Global.lives["lucille"])
	$AdelineLabel.text = "A " + str(Global.lives["adeline"])
