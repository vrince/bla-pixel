extends RigidBody2D

class_name Player

export var id: String = "none"
export var selected: bool = true
export var color: Color = Color.white
export var item: String = ""
export var stomp_impulse: = 600.0
export var jump_impulse: = 200.0
export var speed: = 200.0
export var ground_speed_delta: = 50.0
export var air_speed_delta: = 10.0

export var frames: SpriteFrames

func _ready():
	Global.connect("player_selected", self, "_on_player_selected")
	Global.connect("object_picked", self, "_on_object_picked")
	$AnimatedSprite.frames = frames
	$ItemSprite.visible = false

func _input(e):
	if Input.is_action_pressed(id):
		Global.select_player(id)

func _on_player_selected(old_id: String, new_id: String):
	selected = (new_id == id)
	$Particles2D.emitting = selected
	$Particles2D.process_material.color = color

func _on_object_picked(object: Node2D, player_id: String):
	if item.empty() and player_id == id:
		item = object.id
		$ItemSprite.texture = object.texture
		$ItemSprite.visible = true

func _integrate_forces(state: Physics2DDirectBodyState):
	var is_on_ground := false 
	var touch_right := false
	var touch_left := false
	
	for i in range(state.get_contact_count()):
		is_on_ground = is_on_ground || state.get_contact_local_normal(i).y < -0.9
		touch_right = touch_right || state.get_contact_local_normal(i).x < -0.9
		touch_left = touch_left || state.get_contact_local_normal(i).x > 0.9
	
	var jump = (selected and Input.is_action_pressed("jump")) or Input.is_action_pressed(id + "_jump")
	var right = (selected and Input.get_action_strength("ui_right")) or Input.is_action_pressed(id + "_right")
	var left = (selected and Input.get_action_strength("ui_left")) or Input.is_action_pressed(id + "_left")
	
	if is_on_ground:
		if jump:
			apply_central_impulse(Vector2.UP * jump_impulse)
		if not touch_right and right:
			state.linear_velocity.x += ground_speed_delta
		if not touch_right and left:
			state.linear_velocity.x -= ground_speed_delta
	else:
		if not touch_right and right:
			state.linear_velocity.x += air_speed_delta
		if not touch_left and left:
			state.linear_velocity.x -= air_speed_delta
	state.linear_velocity.x = clamp(state.linear_velocity.x, -speed, speed)
	
	$AnimatedSprite.playing = true 
	if state.linear_velocity.x > 10:
		$AnimatedSprite.flip_h = false
	elif state.linear_velocity.x < -10:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.playing = false
		$AnimatedSprite.frame = 0
	
