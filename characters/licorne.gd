extends KinematicBody2D


var speed = 100
var velocity = Vector2()
var h = 50
var t = 10
var tick = 0.0
var direction = 1.0
var jumped = false
var size = 3

signal catched()

func _ready():
	set_size(size)

func set_size(var s: int):
	size = s
	if $Big:
		$Big.visible = s == 3
		$BigColision.visible = s == 3
	if $Medium:
		$Medium.visible = s == 2
		$MediumColision.visible = s == 2
	$Small.visible = s == 1
	
func _physics_process(delta):
	tick += delta
	var velocity = direction * Vector2(speed, h * sin(t*tick))
	move_and_collide(velocity * delta)

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	direction *= -1.0
	if size == 3:
		speed = rand_range(50,150)
		h = rand_range(50,100)
		position = Vector2(position.x, rand_range(50,150))
	elif size == 2:
		speed = rand_range(100,200)
		h = rand_range(100,150)
		t = 20
		position = Vector2(position.x, rand_range(20,220))
	else:
		speed = rand_range(400,600)
		h = rand_range(20,50)
		t = 100
		position = Vector2(position.x, rand_range(20,100))
	scale = Vector2(-1 * scale.x, scale.y)
	jumped = false

func _on_Area2D_body_entered(body):
	var player = body as Player
	if player:
		$Particles2D2.emitting = true
		if not jumped:
			jumped = true
			if size == 3:
				$Big.queue_free()
				$BigColision.queue_free()
				set_size(2)
			elif size == 2:
				$Medium.queue_free()
				$MediumColision.queue_free()
				set_size(1)
			elif size == 1:
				Global.emit_signal("item_picked", "licorne", player.id, $Small.frames.get_frame('default', 0))
				emit_signal("catched")
				queue_free()
			
