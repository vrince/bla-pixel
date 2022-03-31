extends Node2D

export var energy: float = 0.75

func _ready():
	$Light2D.energy = energy


func _on_Area2D_body_entered(body):
	var player = body as Player
	if player:
		Global.increment_diamond()
		$Tween.interpolate_property(self, "scale", Vector2(1,1), Vector2(0,0),
		0.25, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		$Tween.start()
		yield($Tween, "tween_completed")
		queue_free()
