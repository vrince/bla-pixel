extends Node2D


var stop_book = false

func _ready():
	$AnimatedSprite.playing = true
	$Unicorn.visible = false
	$PoopParticles2D.emitting = false
	$DiamondParticles2D.emitting = false
	$Licorne.set_size(1)
	$Licorne.speed = 0


func _on_Area2D_body_entered(body):
	var player = body as Player
	if player:
		stop_book = true
		if $AnimatedSprite.playing == false and $Unicorn.visible == false:
			if player.item == 'licorne':
				player._on_item_consumed(null, player.id)
				$Unicorn.visible = true
				$DiamondParticles2D.emitting = true
				$PoopParticles2D.emitting = false
			else:
				$DiamondParticles2D.emitting = false
				$PoopParticles2D.emitting = true

func _process(delta):
	if stop_book and $AnimatedSprite.frame == 0:
		$AnimatedSprite.playing = false
		
