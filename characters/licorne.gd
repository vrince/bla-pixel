extends KinematicBody2D


var speed = 100
var velocity = Vector2()
var h = 50
var t = 10
var tick = 0.0
var direction = 1.0
var jumped = false

func _physics_process(delta):
	tick += delta
	var velocity = direction * Vector2(speed, h * sin(t*tick))
	move_and_collide(velocity * delta)

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	direction *= -1.0
	speed = rand_range(50,150)
	h = rand_range(50,100)
	position = Vector2(position.x, rand_range(50,150))
	$AnimatedSprite.flip_h = direction < 0
	jumped = false

func _on_Area2D_body_entered(body):
	var player = body as Player
	if player:
		$Particles2D2.emitting = true
		if not jumped:
			scale = 0.75 * scale
			jumped = true
