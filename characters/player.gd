extends RigidBody2D

class_name Player

export var id: String = "none"
export var selected: bool = true
export var item: String = ""
export var stomp_impulse: = 600.0
export var jump_impulse: = 400.0
export var speed: = 200.0
export var ground_speed_delta: = 50.0
export var air_speed_delta: = 10.0

var player_state : String = ""
var sprite : AnimatedSprite
var particle : Particles2D
var original_position : Vector2
var reset := false

func _ready():
	
	Global.connect("player_selected", self, "_on_player_selected")
	Global.connect("object_picked", self, "_on_object_picked")
	Global.connect("player_exited", self, "_on_player_exited")
	Global.connect("start_new_level", self, "_on_start_new_level")
	
	sprite = get_node("AnimatedSprite") as AnimatedSprite
	particle = get_node("Particles2D") as Particles2D
	if particle:
		particle.emitting = false
	$ItemSprite.visible = false
	
	original_position = get_global_position()
	print(id, " original position ", original_position)
	
	appear()

func _input(e):
	if Input.is_action_pressed(id):
		Global.select_player(id)

func _on_player_selected(old_id: String, new_id: String):
	selected = (new_id == id)
	if particle:
		particle.emitting = selected

func _on_object_picked(object: Node2D, player_id: String):
	if item.empty() and player_id == id:
		item = object.id
		$ItemSprite.texture = object.texture
		$ItemSprite.visible = true

func _on_player_exited(player_id: String):
	if player_id == id:
		disappear()

func _on_start_new_level(level: String):
	print("_on_start_new_level ", id, " ", level, " pos ", position)

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	print("viewport exist ", id, " go back to ", original_position)
	reset = true
	scale = Vector2(0,0)

func _integrate_forces(state: Physics2DDirectBodyState):
	if reset:
		appear()
		linear_velocity = Vector2(0,0)
		set_global_position(original_position)
		reset = false
	
	var is_on_ground := false 
	var touch_right := false
	var touch_left := false
	var jumping = state.linear_velocity.y < -10
	
	for i in range(state.get_contact_count()):
		is_on_ground = is_on_ground || state.get_contact_local_normal(i).y < -0.1
		touch_right = touch_right || state.get_contact_local_normal(i).x < -0.9
		touch_left = touch_left || state.get_contact_local_normal(i).x > 0.9
	
	var jump = (selected and Input.is_action_pressed("jump")) or Input.is_action_pressed(id + "_jump")
	var right = (selected and Input.get_action_strength("ui_right")) or Input.is_action_pressed(id + "_right")
	var left = (selected and Input.get_action_strength("ui_left")) or Input.is_action_pressed(id + "_left")
	
	if is_on_ground:
		if not jumping and jump:
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
	
	if state.linear_velocity.x > 10:
		player_state = "moving_right"
	elif state.linear_velocity.x < -10:
		player_state = "moving_left"
	else:
		player_state = ""
		
	if sprite:
		sprite.playing = ("moving" in player_state)
		sprite.flip_h = ("left" in player_state)
	  
func appear():
	var tween = $Tween
	tween.interpolate_property(self, "scale", Vector2(0,0), Vector2(1,1), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
func disappear():
	var tween = $Tween
	tween.interpolate_property(self, "scale", Vector2(1,1), Vector2(0,0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_completed")
	queue_free()

