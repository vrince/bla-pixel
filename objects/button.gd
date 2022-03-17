extends StaticBody2D

export var id : String = "button"
export var single_shot : bool = true
var pressed_by : String = ""

func _on_Area2D_body_entered(body):
	if body is Player and pressed_by.empty():
		pressed_by = body.id
		$Particles2D.emitting = true
		$AnimatedSprite.animation = "pressed"
		Global.emit_signal("button_pressed", id, body.id)


func _on_Area2D_body_exited(body):
	if not single_shot:
		if body is Player and pressed_by == body.id:
			pressed_by = ""
			$AnimatedSprite.animation = "default"
			Global.emit_signal("button_released", id, body.id)
