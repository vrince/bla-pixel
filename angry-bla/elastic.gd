extends Line2D

export var stiffness := 1.0
var on_slingshot = false
var shoot = false
var impulse_direction = Vector2.ZERO
var player = null

const POULE = preload("res://angry-bla/poule.tscn")

func _ready():
	reload()
	pass

func reload():
	player = POULE.instance()
	add_child(player)
	player.connect("released", self, "_on_poule_released")
	on_slingshot = true
	shoot = false

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if not on_slingshot:
			reload()

func _process(delta):
	if on_slingshot:
		points[1] = player.position
		if shoot:
			player.apply_central_impulse(stiffness * impulse_direction * player.position.length())
			#player.get_node("Player").apply_torque_impulse(25 * delta)
			on_slingshot = false
			shoot = false
			points[1] = Vector2.ZERO


func _on_poule_released():
	if on_slingshot and not shoot:
		impulse_direction = - player.position.normalized()
		shoot = true
