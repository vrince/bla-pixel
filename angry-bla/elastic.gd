extends Line2D

var on_slingshot = true
var impulse_direction = Vector2.ZERO
var player = null

func _ready():
	pass

func _process(delta):
	if on_slingshot:
		var player_relative_position = player.position - position
		points[1] = player_relative_position
		if(impulse_direction.length() > 0):
			player.get_node("Player").apply_central_impulse(1000 * impulse_direction)
			#player.get_node("Player").apply_torque_impulse(25 * delta)
			on_slingshot = false
			points[1] = Vector2.ZERO


func _on_player_released():
	print("_on_player_released")
	impulse_direction = (position - player.position).normalized()
	print(impulse_direction)
