extends RigidBody2D

export var id := "lock"

func _ready():
	pass

func _on_Area2D_body_entered(body):
	if visible:
		var player = body as Player
		if player:
			if player.item == id:
				Global.emit_signal("item_consumed", self, player.id)
				queue_free()

