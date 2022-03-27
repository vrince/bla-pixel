extends Control


func _ready():
	Global.connect("count_down", self, "_on_count_down")

func _on_count_down(time):
	$Label.text = str(int(time / 60)) + ":" + str(fmod(time,60))
