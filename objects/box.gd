extends RigidBody2D

class_name Box

func _ready():
	scale = Vector2(0,0)
	var tween = $Tween
	tween.interpolate_property(self, "scale", Vector2(0,0), Vector2(1,1), 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()


