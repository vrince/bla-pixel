extends RigidBody2D

class_name Poule

const names = ['kipo', 'chipolata']

signal released

export var poule := 'kipo'
export var impulse := 2.5

var drag_enabled = false
var original_position = Vector2.ZERO

func _ready():
	mode = RigidBody2D.MODE_STATIC
	$AnimatedSprite.animation = poule + '-idle'
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
	var flying = linear_velocity.length() > 0.1 
	
	if drag_enabled:
		position = get_global_mouse_position() - get_parent().position
		
	$AnimatedSprite.animation = poule + ('-fly' if flying else '-idle')
	
	if flying and Input.is_action_pressed("ui_accept"):
		if poule == 'kipo' and linear_velocity.y > 0:
			apply_central_impulse(impulse * Vector2(1.0,-2.0))
		if poule == 'chipolata' and linear_velocity.y > 0:
			apply_central_impulse(impulse * Vector2.UP)
		elif poule == 'hermione' and linear_velocity.x > 0:
			apply_central_impulse(impulse * Vector2.LEFT)



func _on_VisibilityNotifier2D_viewport_exited(viewport):
	if not drag_enabled:
	 queue_free()
