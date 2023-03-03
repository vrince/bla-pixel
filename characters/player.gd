extends RigidBody2D

class_name Player

export var id: String = "none"
export var selected: String = ""
export var item: String = ""
export var stomp_impulse: = 100.0
export var jump_impulse: = 15.0
export var speed: = 200.0
export var ground_speed_delta: = 50.0
export var air_speed_delta: = 10.0

var player_state : String = ""
var sprite : AnimatedSprite
var particle : Particles2D
var original_position : Vector2
var original_scale : Vector2
var reset := false
var reset_timer = null

var jump_counter = 0
var is_on_ground = false
var is_on_player = false
var touch_right = false
var touch_left = false

func _ready():
	Global.connect("player_selected", self, "_on_player_selected")
	Global.connect("item_picked", self, "_on_item_picked")
	Global.connect("item_consumed", self, "_on_item_consumed")
	Global.connect("player_exited", self, "_on_player_exited")
	Global.connect("start_new_level", self, "_on_start_new_level")
	
	sprite = get_node("AnimatedSprite") as AnimatedSprite
	$ItemSprite.visible = false
	$Particles2D.emitting = false
	
	original_position = get_global_position()
	original_scale = get_parent().scale
	
	reset_timer = Timer.new()
	add_child(reset_timer)
	reset_timer.set_one_shot(true)
	reset_timer.connect("timeout", self, "_on_reset_timeout")

func _on_player_selected(old_id: String, new_id: String):
	selected = new_id
	$Particles2D.emitting = (id == selected)

func _on_item_picked(new_item: String, player_id: String, texture: Texture):
	if item.empty() and player_id == id:
		item = new_item
		$ItemSprite.texture = texture
		$ItemSprite.visible = true

func _on_item_consumed(object: Node2D, player_id: String):
	if player_id == id:
		item = ""
		$ItemSprite.visible = false

func _on_player_exited(player_id: String):
	if player_id == id:
		disappear()

func _on_start_new_level(level: String):
	pass

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	reset = true
	scale = Vector2(0,0)

func _on_reset_timeout():
	Global.new_player(id)

func _integrate_forces(state: Physics2DDirectBodyState):
	if reset:
		appear()
		linear_velocity = Vector2(0,0)
		set_global_position(original_position)
		reset = false
		if reset_timer.is_stopped():
			reset_timer.start(0.5)
	
	is_on_ground = len($Area2DGround.get_overlapping_bodies()) > 0
	is_on_player = len($Area2DPlayer.get_overlapping_bodies()) > 1 #current player overlap always
	touch_right = len($Area2DRight.get_overlapping_bodies()) > 0
	touch_left = len($Area2DLeft.get_overlapping_bodies()) > 0
	
	var jump = ((id == selected) and Input.is_action_pressed("jump")) or (("none" == selected) && Input.is_action_pressed(id + "_jump"))
	var right = ((id == selected) and Input.get_action_strength("right")) or (("none" == selected) && Input.is_action_pressed(id + "_right"))
	var left = ((id == selected) and Input.get_action_strength("left")) or (("none" == selected) && Input.is_action_pressed(id + "_left"))
	
	var is_jumping = (jump_counter > 0) && (jump_counter < 30)
	
	if jump:
		if is_jumping:
			jump_counter += 1
			apply_central_impulse(Vector2.UP * jump_impulse)
	else:
		jump_counter = 0
	
	if is_on_ground:
		if jump:
			jump_counter += 1
			apply_central_impulse(Vector2.UP * jump_impulse)
		if right:
			state.linear_velocity.x += ground_speed_delta
		if left:
			state.linear_velocity.x -= ground_speed_delta
	elif is_on_player and jump:
		if jump_counter == 0:
			jump_counter += 1
			apply_central_impulse(Vector2.UP * stomp_impulse)
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
		player_state = player_state.replace("moving_", "")
		
	if sprite:
		sprite.playing = ("moving" in player_state)
		sprite.flip_h = ("left" in player_state)
	  
func appear():
	var tween = $Tween
	tween.interpolate_property(self, "scale", Vector2(0,0), original_scale, 0.5, 
	Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
	
func disappear():
	var tween = $Tween
	tween.interpolate_property(self, "scale", original_scale, Vector2(0,0), 0.5,
	Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_completed")
	queue_free()
