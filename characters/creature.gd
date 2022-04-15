extends Node2D

signal released

var drag_enabled = false
var player = null

func _ready():
	$Player.mode = RigidBody2D.MODE_STATIC
	$Player/Particles2D.emitting = false

func _input_event(viewport, event, shape_idx):
	if $Player.mode == RigidBody2D.MODE_STATIC:
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT:
				drag_enabled = event.pressed
				if(not drag_enabled):
					$Player.mode = RigidBody2D.MODE_RIGID
					emit_signal("released")

func _physics_process(delta):
	if drag_enabled:
		position = get_global_mouse_position()
