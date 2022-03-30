extends Node2D

class_name Pick

export var id := "object"
export var type := "key"
var texture : Texture

func _ready():
	$AnimatedSprite.animation = type
	texture = $AnimatedSprite.frames.get_frame(type, 0)

func _on_Area2D_body_entered(body):
	if visible && get_parent().visible:
		var player = body as Player
		if player and player.item.empty():
			Global.emit_signal("item_picked", self, player.id)
			queue_free()
