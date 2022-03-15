extends StaticBody2D

export var id : String = "button"

func _on_Area2D_body_entered(body):
	if body is Player:
		if $AnimatedSprite.animation != "pressed":
			$Particles2D.emitting = true
			$AnimatedSprite.animation = "pressed"
			Global.emit_signal("button_pressed", id, body.id)
