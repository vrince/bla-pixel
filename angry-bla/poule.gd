extends RigidBody2D

signal released

var drag_enabled = false
var original_position = Vector2.ZERO

func _ready():
	mode = RigidBody2D.MODE_STATIC
	$AnimatedSprite.animation = 'default'
	original_position = position

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if mode == RigidBody2D.MODE_STATIC:
			if event.button_index == BUTTON_LEFT:
				drag_enabled = event.pressed
				if not drag_enabled:
					mode = RigidBody2D.MODE_CHARACTER
					emit_signal("released")

func _physics_process(delta):
	if drag_enabled:
		position = get_global_mouse_position() - get_parent().position
	$AnimatedSprite.animation = 'default' if linear_velocity.length() < 0.1 else 'fly'

