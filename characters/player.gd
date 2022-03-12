extends RigidBody2D

export var id: int = KEY_1
export var selected: bool = true
export var stomp_impulse: = 600.0
export var jump_impulse: = 200.0
export var speed: = 200.0
export var ground_speed_delta: = 50.0
export var air_speed_delta: = 10.0

func _ready():
	Global.connect("player_selected", self, "_on_player_selected")

func _input(e):
	if e is InputEventKey:
		if e.scancode == id:
			Global.select_player(id)

func _on_player_selected(old_id: int, new_id: int):
	selected = (new_id == id)
	$Particles2D.emitting = selected

func _integrate_forces(state: Physics2DDirectBodyState):
	
	if not selected:
		return
	
	var is_on_ground := false 
	var touch_right := false
	var touch_left := false
	
	for i in range(state.get_contact_count()):
		is_on_ground = is_on_ground || state.get_contact_local_normal(i).y < -0.9
		touch_right = touch_right || state.get_contact_local_normal(i).x < -0.9
		touch_left = touch_left || state.get_contact_local_normal(i).x > 0.9
	
	if is_on_ground:
		if Input.is_action_pressed("jump"):
			apply_central_impulse(Vector2.UP * jump_impulse)
		if not touch_right and Input.get_action_strength("ui_right"):
			state.linear_velocity.x += ground_speed_delta
		if not touch_left and Input.get_action_strength("ui_left"):
			state.linear_velocity.x -= ground_speed_delta
	else:
		if not touch_right and Input.get_action_strength("ui_right"):
			state.linear_velocity.x += air_speed_delta
		if not touch_left and Input.get_action_strength("ui_left"):
			state.linear_velocity.x -= air_speed_delta
	state.linear_velocity.x = clamp(state.linear_velocity.x, -speed, speed)
	
	$AnimatedSprite.playing = true 
	if state.linear_velocity.x > 10:
		$AnimatedSprite.flip_h = true
	elif state.linear_velocity.x < -10:
		$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.playing = false
		$AnimatedSprite.frame = 0
	
